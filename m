Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3BE47FF51
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbhL0Pgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39698 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbhL0Pe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F30ACE10B3;
        Mon, 27 Dec 2021 15:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91598C36AE7;
        Mon, 27 Dec 2021 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619295;
        bh=EGJYDXlMHeVDNvyRLl978rsNAxVBC7mC247kkSuqSb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX6IOiGgsXCKeWYYjr+CFT/yyZ68IXxegmUluTUBmcJ+02B1+aq2PW/5Y9tqYs4Mw
         FDazIio+2iTSMc11Q6scRe1SiQBZZZO6FWioIuYy6GOdphDv2n9UYBzZr+WlWi7R4r
         U/XDkPurENGYtsUjgZG+BNn7MdphuXnrVc109cNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 22/47] ALSA: jack: Check the return value of kstrdup()
Date:   Mon, 27 Dec 2021 16:30:58 +0100
Message-Id: <20211227151321.560306522@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

commit c01c1db1dc632edafb0dff32d40daf4f9c1a4e19 upstream.

kstrdup() can return NULL, it is better to check the return value of it.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/tencent_094816F3522E0DC704056C789352EBBF0606@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/jack.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -220,6 +220,10 @@ int snd_jack_new(struct snd_card *card,
 		return -ENOMEM;
 
 	jack->id = kstrdup(id, GFP_KERNEL);
+	if (jack->id == NULL) {
+		kfree(jack);
+		return -ENOMEM;
+	}
 
 	/* don't creat input device for phantom jack */
 	if (!phantom_jack) {


