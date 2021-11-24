Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CA145BAE7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbhKXMPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242543AbhKXML7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 047A961164;
        Wed, 24 Nov 2021 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755606;
        bh=/x2ClrqaTOta+DF2x4Ym8ixi/d/d//U31mHF5WWTMFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrqOnA1XqA/HTU00Lacm4+G6y/2TqWSLupvr840GZC89LSlZ4mIxPACtdUCai7KFD
         Uq1idXV4uEgIsdUHBxC1yts22thPnvYUP0SiFX0n2JIPJpoxa0PghVwh+JVULQ3vkv
         1J6yTG6YwJsNGLYYBrhWs1pkt0igM629m/n/e9YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 155/162] batman-adv: set .owner to THIS_MODULE
Date:   Wed, 24 Nov 2021 12:57:38 +0100
Message-Id: <20211124115703.293867014@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

commit 14a2e551faea53d45bc11629a9dac88f88950ca7 upstream.

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: switch to old filename. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -214,6 +214,7 @@ static const struct file_operations bata
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner          = THIS_MODULE,
 };
 
 static int batadv_debug_log_setup(struct batadv_priv *bat_priv)


