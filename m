Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E3B157AC4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbgBJNZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgBJMg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD952467C;
        Mon, 10 Feb 2020 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338215;
        bh=bp8wiRWbr57NzUapszvTFASMRRI7kJytZuF7/tWWOxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd0KHSFHgqiXqRXCak0AMmz0mMgAidLFF8eeMceLGWuhorPfybYH1aeGwFN0UYqWH
         CTDzxXbLwbq88w64bpOQiwLJDlU+PlUmqC1cfdaAPvBfsCFvMph/mzlv9F8kqsUnNX
         ePwIaQjfiZID3sQ9Ntpgc50jdEBiIJf3wOjRJP/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 009/309] bnxt_en: Fix TC queue mapping.
Date:   Mon, 10 Feb 2020 04:29:25 -0800
Message-Id: <20200210122406.952098667@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 18e4960c18f484ac288f41b43d0e6c4c88e6ea78 ]

The driver currently only calls netdev_set_tc_queue when the number of
TCs is greater than 1.  Instead, the comparison should be greater than
or equal to 1.  Even with 1 TC, we need to set the queue mapping.

This bug can cause warnings when the number of TCs is changed back to 1.

Fixes: 7809592d3e2e ("bnxt_en: Enable MSIX early in bnxt_init_one().")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7873,7 +7873,7 @@ static void bnxt_setup_msix(struct bnxt
 	int tcs, i;
 
 	tcs = netdev_get_num_tc(dev);
-	if (tcs > 1) {
+	if (tcs) {
 		int i, off, count;
 
 		for (i = 0; i < tcs; i++) {


