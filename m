Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7667B499DC5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586211AbiAXWZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583235AbiAXWR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34BBC06138E;
        Mon, 24 Jan 2022 12:48:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B272DB81063;
        Mon, 24 Jan 2022 20:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA344C340E5;
        Mon, 24 Jan 2022 20:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057291;
        bh=PJBaakTJqJ7uadR58mhjBkXOGvr1mslmS/bj9utbnjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvnd/UBaVYIVaeVW/saZtL0wHhQCZlQrfTUgB5dy1z7P7t19+83K14ibXq93m//Lj
         eB6tAGiFDJLyECektxeXiXP+2tjkrGzP6cjWlmpI+SibtF/Da7h1Wowvifvv+uwhMd
         IyZ4KHeJuIDNCJIiKu0WK6VuqFqswQlay6GeoQIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 765/846] xdp: check prog type before updating BPF link
Date:   Mon, 24 Jan 2022 19:44:42 +0100
Message-Id: <20220124184127.349600297@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -9636,6 +9636,12 @@ static int bpf_xdp_link_update(struct bp
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


