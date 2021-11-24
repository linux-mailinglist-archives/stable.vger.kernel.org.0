Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D8D45BAF4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242797AbhKXMPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242900AbhKXMNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:13:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAFE610CC;
        Wed, 24 Nov 2021 12:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755635;
        bh=Ar0nDp31+5EHseMccXMxhYC/hi4kdrSoZwqAji6xVOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXI8yxJJlmRT52zPkSH9ITdS2Rs6fn2jNLMct64ef4oOZ30JmaKhe+KMmrGyxJM8U
         SvBT0/VMujOmxmY6eqXeCfDnUcJUvNJHv0/32dRE/HSYSihOuXmxgt5AaykJvcCJr/
         S8lJPvOsSRUL11dUGFmGt7IvN1cOgNkmA9crCMuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 159/162] batman-adv: Avoid WARN_ON timing related checks
Date:   Wed, 24 Nov 2021 12:57:42 +0100
Message-Id: <20211124115703.419182207@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 9f460ae31c4435fd022c443a6029352217a16ac1 upstream.

The soft/batadv interface for a queued OGM can be changed during the time
the OGM was queued for transmission and when the OGM is actually
transmitted by the worker.

But WARN_ON must be used to denote kernel bugs and not to print simple
warnings. A warning can simply be printed using pr_warn.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com
Fixes: ef0a937f7a14 ("batman-adv: consider outgoing interface in OGM sending")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: adjust context. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -526,8 +526,10 @@ static void batadv_iv_ogm_emit(struct ba
 	if (WARN_ON(!forw_packet->if_outgoing))
 		goto out;
 
-	if (WARN_ON(forw_packet->if_outgoing->soft_iface != soft_iface))
+	if (forw_packet->if_outgoing->soft_iface != soft_iface) {
+		pr_warn("%s: soft interface switch for queued OGM\n", __func__);
 		goto out;
+	}
 
 	if (forw_packet->if_incoming->if_status != BATADV_IF_ACTIVE)
 		goto out;


