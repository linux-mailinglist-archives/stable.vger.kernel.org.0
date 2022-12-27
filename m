Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849296569FC
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 12:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiL0Lda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 06:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiL0Ld1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 06:33:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06307B1
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 03:33:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 333A4CE0FB9
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 11:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE01CC433EF;
        Tue, 27 Dec 2022 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672140803;
        bh=nZ4J9dG/W6VFT9G1COcVGMBPZlBGlOdKG4pxp1J85IQ=;
        h=Subject:To:Cc:From:Date:From;
        b=YyNEBHVsjYy5b9cu+peO0EE1M8R3VQiNv0qmFKbtaG5ycTTb2A4k9O2bLxaSskDpz
         SD02HSH8C8bBDFN7dPOC87uFqBKPIJ5OgpFX4qRiaDHE93iPPxJNzsCWMZGtfgPhdz
         3iNOY3o6lw4SLyk3KRpPnQEw2afX65yYybLr8pHY=
Subject: FAILED: patch "[PATCH] bpf: Resolve fext program type when checking map" failed to apply to 6.0-stable tree
To:     toke@redhat.com, martin.lau@kernel.org, yhs@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Dec 2022 12:33:12 +0100
Message-ID: <167214079219520@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1c123c567fb1 ("bpf: Resolve fext program type when checking map compatibility")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c123c567fb138ebd187480b7fc0610fcb0851f5 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Date: Thu, 15 Dec 2022 00:02:53 +0100
Subject: [PATCH] bpf: Resolve fext program type when checking map
 compatibility
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The bpf_prog_map_compatible() check makes sure that BPF program types are
not mixed inside BPF map types that can contain programs (tail call maps,
cpumaps and devmaps). It does this by setting the fields of the map->owner
struct to the values of the first program being checked against, and
rejecting any subsequent programs if the values don't match.

One of the values being set in the map owner struct is the program type,
and since the code did not resolve the prog type for fext programs, the map
owner type would be set to PROG_TYPE_EXT and subsequent loading of programs
of the target type into the map would fail.

This bug is seen in particular for XDP programs that are loaded as
PROG_TYPE_EXT using libxdp; these cannot insert programs into devmaps and
cpumaps because the check fails as described above.

Fix the bug by resolving the fext program type to its target program type
as elsewhere in the verifier.

v3:
- Add Yonghong's ACK

Fixes: f45d5b6ce2e8 ("bpf: generalise tail call map compatibility check")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221214230254.790066-1-toke@redhat.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7f98dec6e90f..b334f4ddc4d5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2092,6 +2092,7 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_map_compatible(struct bpf_map *map,
 			     const struct bpf_prog *fp)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
 
 	if (fp->kprobe_override)
@@ -2102,12 +2103,12 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		map->owner.type  = fp->type;
+		map->owner.type  = prog_type;
 		map->owner.jited = fp->jited;
 		map->owner.xdp_has_frags = fp->aux->xdp_has_frags;
 		ret = true;
 	} else {
-		ret = map->owner.type  == fp->type &&
+		ret = map->owner.type  == prog_type &&
 		      map->owner.jited == fp->jited &&
 		      map->owner.xdp_has_frags == fp->aux->xdp_has_frags;
 	}

