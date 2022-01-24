Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8A499180
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379377AbiAXULU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378242AbiAXUGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45D59B8122F;
        Mon, 24 Jan 2022 20:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEA4C340E5;
        Mon, 24 Jan 2022 20:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054798;
        bh=U2lQl/MZ0d0+YaTq1QYVKR854nG4+BKuzrVJGOnA0c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RmT19GfgKaPgmPtCOFkOKaFMAHxxmPBEcguIMka1TY2W89ONlxjMNAfKUYKoZRMUe
         mUN50MOdSTzMyexuQPGXY9Foprc0XO9msEz2a/ZS/xhfL1N8ANTkupCtIrMWs2/FHP
         FvD1o0QeAahHUfHGChi8el6LuWl8vnl6z5+g2Wng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 507/563] xdp: check prog type before updating BPF link
Date:   Mon, 24 Jan 2022 19:44:32 +0100
Message-Id: <20220124184042.004368957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 382778edc8262b7535f00523e9eb22edba1b9816 upstream.

The bpf_xdp_link_update() function didn't check the program type before
updating the program, which made it possible to install any program type as
an XDP program, which is obviously not good. Syzbot managed to trigger this
by swapping in an LWT program on the XDP hook which would crash in a helper
call.

Fix this by adding a check and bailing out if the types don't match.

Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20220107221115.326171-1-toke@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9339,6 +9339,12 @@ static int bpf_xdp_link_update(struct bp
 		goto out_unlock;
 	}
 	old_prog = link->prog;
+	if (old_prog->type != new_prog->type ||
+	    old_prog->expected_attach_type != new_prog->expected_attach_type) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (old_prog == new_prog) {
 		/* no-op, don't disturb drivers */
 		bpf_prog_put(new_prog);


