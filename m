Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEA968D86E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBGNJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjBGNJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED249008
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E872B81995
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA3BC433EF;
        Tue,  7 Feb 2023 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775295;
        bh=bmO0opIXXod8eYZ3Rq2Qyh9+FxwaSkw57Q2LFjvdJlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKUg91eO5jwE6tiLVHQ16BL9RiZei69LuR/Zp2PdlQ0pa5RMCfXEOZwOe5rO7NEDl
         JFLDOrxjsO4t6MJuGkHggXzp4bbHoMpc2wQ+DaWhCT0x4UvyWEdyj8TIPvGC5wGagX
         FFSu3faVe8deJwvSCv+QajJ4ZhIVXwgsnpIKcyp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 201/208] ovl: Use "buf" flexible array for memcpy() destination
Date:   Tue,  7 Feb 2023 13:57:35 +0100
Message-Id: <20230207125643.602050455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit cf8aa9bf97cadf85745506c6a3e244b22c268d63 upstream.

The "buf" flexible array needs to be the memcpy() destination to avoid
false positive run-time warning from the recent FORTIFY_SOURCE
hardening:

  memcpy: detected field-spanning write (size 93) of single field "&fh->fb"
  at fs/overlayfs/export.c:799 (size 21)

Reported-by: syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000763a6c05e95a5985@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/export.c    |    2 +-
 fs/overlayfs/overlayfs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -796,7 +796,7 @@ static struct ovl_fh *ovl_fid_to_fh(stru
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy unaligned inner fh into aligned buffer */
-	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
+	memcpy(fh->buf, fid, buflen - OVL_FH_WIRE_OFFSET);
 	return fh;
 }
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -108,7 +108,7 @@ struct ovl_fh {
 	u8 padding[3];	/* make sure fb.fid is 32bit aligned */
 	union {
 		struct ovl_fb fb;
-		u8 buf[0];
+		DECLARE_FLEX_ARRAY(u8, buf);
 	};
 } __packed;
 


