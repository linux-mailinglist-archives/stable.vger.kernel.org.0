Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E9A45C19C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347812AbhKXNT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348922AbhKXNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:18:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954786108F;
        Wed, 24 Nov 2021 12:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757945;
        bh=hm+LoMnKo2zPalmH+vA/R5od+30Dmt5EFVQPQFKBG6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1Fq+aWuCXSZWmvmxmAAna5eK0zzsQDHYpabg9GDCRQ3URKbZS4C+XCtDWNRlZptG
         uMRUv3Fbqn59SDPAGmsCVlkDv8gKuMHjRLHFt0bTT9saENND477AsiHHbjzUVoefcs
         fnzowJRIkDzi8JFFwY+zz69QjOaxQLmDrk138tVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 299/323] NFC: reorganize the functions in nci_request
Date:   Wed, 24 Nov 2021 12:58:09 +0100
Message-Id: <20211124115729.006031332@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 86cdf8e38792545161dbe3350a7eced558ba4d15 ]

There is a possible data race as shown below:

thread-A in nci_request()       | thread-B in nci_close_device()
                                | mutex_lock(&ndev->req_lock);
test_bit(NCI_UP, &ndev->flags); |
...                             | test_and_clear_bit(NCI_UP, &ndev->flags)
mutex_lock(&ndev->req_lock);    |
                                |

This race will allow __nci_request() to be awaked while the device is
getting removed.

Similar to commit e2cb6b891ad2 ("bluetooth: eliminate the potential race
condition when removing the HCI controller"). this patch alters the
function sequence in nci_request() to prevent the data races between the
nci_close_device().

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Link: https://lore.kernel.org/r/20211115145600.8320-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 33c23af6709d4..1008bbbb3af9c 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -156,12 +156,15 @@ inline int nci_request(struct nci_dev *ndev,
 {
 	int rc;
 
-	if (!test_bit(NCI_UP, &ndev->flags))
-		return -ENETDOWN;
-
 	/* Serialize all requests */
 	mutex_lock(&ndev->req_lock);
-	rc = __nci_request(ndev, req, opt, timeout);
+	/* check the state after obtaing the lock against any races
+	 * from nci_close_device when the device gets removed.
+	 */
+	if (test_bit(NCI_UP, &ndev->flags))
+		rc = __nci_request(ndev, req, opt, timeout);
+	else
+		rc = -ENETDOWN;
 	mutex_unlock(&ndev->req_lock);
 
 	return rc;
-- 
2.33.0



