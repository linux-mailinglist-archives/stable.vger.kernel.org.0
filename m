Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41C719921F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbgCaJAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbgCaJAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:00:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11BF820B1F;
        Tue, 31 Mar 2020 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645252;
        bh=ho35sVTquqF+nMCh8sjY2bccs/JY5rCm7rSUWaXHH/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKun6qYpPzAbtYm3X9Xcdz/ORnTYin8I40yoHlLSwVbI6XwMethJw50eCplNlS5HO
         CcC/m/Qa3yeLHfSIfFmXWkF51E83+uw5fh54AvfWURlGxlHjpXLZe4vZPA5/1JlWmp
         zNt5pN8uuulsYkc3YgQnqsflcjRbJatKAPAJgLAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        syzbot+7d42d68643a35f71ac8a@syzkaller.appspotmail.com
Subject: [PATCH 5.6 13/23] staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback
Date:   Tue, 31 Mar 2020 10:59:25 +0200
Message-Id: <20200331085314.292545907@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit 1165dd73e811a07d947aee218510571f516081f6 upstream.

We can't handle the case length > WLAN_DATA_MAXLEN.
Because the size of rxfrm->data is WLAN_DATA_MAXLEN(2312), and we can't
read more than that.

Thanks-to: Hillf Danton <hdanton@sina.com>
Reported-and-tested-by: syzbot+7d42d68643a35f71ac8a@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200326131850.17711-1-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3372,6 +3372,8 @@ static void hfa384x_int_rxmonitor(struct
 	     WLAN_HDR_A4_LEN + WLAN_DATA_MAXLEN + WLAN_CRC_LEN)) {
 		pr_debug("overlen frm: len=%zd\n",
 			 skblen - sizeof(struct p80211_caphdr));
+
+		return;
 	}
 
 	skb = dev_alloc_skb(skblen);


