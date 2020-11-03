Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6672A569D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgKCU7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732507AbgKCU7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5A0223AC;
        Tue,  3 Nov 2020 20:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437156;
        bh=tDP9tNKvXcz9W4/Ob2VP0SNZMWutwGjYqRUALACOOio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeTnclL+AEScoKuxRKJCdXSekaJ4uiJQaW2iVlAfOTKHdN+bTufOIo4001DbBzPwl
         BHIJb2wOxO/NXWxV2OOobijkVHl83hc416YTlDb7PwpahdA16yFI0s9z3Ctmojb/AK
         fQniQiyKaplv5FkVw5eq6rheg9Nd/B68J+Jq5KyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 171/214] ubifs: Dont parse authentication mount options in remount process
Date:   Tue,  3 Nov 2020 21:36:59 +0100
Message-Id: <20201103203306.775312263@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit bb674a4d4de1032837fcbf860a63939e66f0b7ad upstream.

There is no need to dump authentication options while remounting,
because authentication initialization can only be doing once in
the first mount process. Dumping authentication mount options in
remount process may cause memory leak if UBIFS has already been
mounted with old authentication mount options.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>  # 4.20+
Fixes: d8a22773a12c6d7 ("ubifs: Enable authentication support")
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1092,14 +1092,20 @@ static int ubifs_parse_options(struct ub
 			break;
 		}
 		case Opt_auth_key:
-			c->auth_key_name = kstrdup(args[0].from, GFP_KERNEL);
-			if (!c->auth_key_name)
-				return -ENOMEM;
+			if (!is_remount) {
+				c->auth_key_name = kstrdup(args[0].from,
+								GFP_KERNEL);
+				if (!c->auth_key_name)
+					return -ENOMEM;
+			}
 			break;
 		case Opt_auth_hash_name:
-			c->auth_hash_name = kstrdup(args[0].from, GFP_KERNEL);
-			if (!c->auth_hash_name)
-				return -ENOMEM;
+			if (!is_remount) {
+				c->auth_hash_name = kstrdup(args[0].from,
+								GFP_KERNEL);
+				if (!c->auth_hash_name)
+					return -ENOMEM;
+			}
 			break;
 		case Opt_ignore:
 			break;


