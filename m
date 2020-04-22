Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAED1B3C8E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgDVKGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbgDVKGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC9520575;
        Wed, 22 Apr 2020 10:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550003;
        bh=aduk6n1i/K9ugGri0wivd5UdqpnQ1CSzRXLqmPF38Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAkK5ZXe/hgR3wRZHmg9JiDdAXXY1+iBTmKnvxnkvC6lZzaELnn7lu6K8J1z/1kfK
         Sqxzu1rmMdG/UujNhFs8aQQQMB3NswrFKI7+JEkJw1LkA6zG3LLeJNV23kObDiWYuW
         bEKtpPAKYnuwIUrWst9Dw2HvcYnwSfNGvfcYjmkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 093/125] wil6210: fix temperature debugfs
Date:   Wed, 22 Apr 2020 11:56:50 +0200
Message-Id: <20200422095048.265685753@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 6d9eb7ebae3d7e951bc0999235ae7028eb4cae4f ]

For negative temperatures, "temp" debugfs is showing wrong values.
Use signed types so proper calculations is done for sub zero
temperatures.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1091,7 +1091,7 @@ static const struct file_operations fops
 };
 
 /*---------temp------------*/
-static void print_temp(struct seq_file *s, const char *prefix, u32 t)
+static void print_temp(struct seq_file *s, const char *prefix, s32 t)
 {
 	switch (t) {
 	case 0:
@@ -1099,7 +1099,8 @@ static void print_temp(struct seq_file *
 		seq_printf(s, "%s N/A\n", prefix);
 	break;
 	default:
-		seq_printf(s, "%s %d.%03d\n", prefix, t / 1000, t % 1000);
+		seq_printf(s, "%s %s%d.%03d\n", prefix, (t < 0 ? "-" : ""),
+			   abs(t / 1000), abs(t % 1000));
 		break;
 	}
 }
@@ -1107,7 +1108,7 @@ static void print_temp(struct seq_file *
 static int wil_temp_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
-	u32 t_m, t_r;
+	s32 t_m, t_r;
 	int rc = wmi_get_temperature(wil, &t_m, &t_r);
 
 	if (rc) {


