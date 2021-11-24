Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F3645C38B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350510AbhKXNkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349367AbhKXNiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 507E26322A;
        Wed, 24 Nov 2021 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758576;
        bh=NrSlu56q8yV72/h3x54ISs9qgKaxdnM/7LLMfMyRo8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cpz+oaqi3x+kHYlAh4maGM0sVa6MF6WibrDlSOPI0H9AllQi0OzDY7R2j4v+XLy66
         SZeP3+qfaiNHKVEHDk11T78oHLSSx32CupnZ1u6wpuy3VY0cddNCMD97lBcFnLWhe0
         Cp0F3Oxr9zr9uAeCN5qFDOloUc/Of1NSh5SWYung=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/154] NFC: reorganize the functions in nci_request
Date:   Wed, 24 Nov 2021 12:58:23 +0100
Message-Id: <20211124115705.748293983@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index 32e8154363cab..5e55cb6c087a2 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -144,12 +144,15 @@ inline int nci_request(struct nci_dev *ndev,
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



