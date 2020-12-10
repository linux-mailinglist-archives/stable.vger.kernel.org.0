Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C32E2D62CA
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 18:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbgLJOg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390987AbgLJOgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:14 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 48/54] rtw88: debug: Fix uninitialized memory in debugfs code
Date:   Thu, 10 Dec 2020 15:27:25 +0100
Message-Id: <20201210142604.382672888@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 74a8c816fa8fa7862df870660e9821abb56649fe upstream.

This code does not ensure that the whole buffer is initialized and none
of the callers check for errors so potentially none of the buffer is
initialized.  Add a memset to eliminate this bug.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/X8ilOfVz3pf0T5ec@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -146,6 +146,8 @@ static int rtw_debugfs_copy_from_user(ch
 {
 	int tmp_len;
 
+	memset(tmp, 0, size);
+
 	if (count < num)
 		return -EFAULT;
 


