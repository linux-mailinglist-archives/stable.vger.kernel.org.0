Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D308E411FBD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345431AbhITRpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353004AbhITRnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817ED61B70;
        Mon, 20 Sep 2021 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157742;
        bh=AdD4mtfYZw0C0iPaKI3nyNKRGSSddrfhFKaWWlQol4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9u5P5TKpBMJgzlhyTN+wl9k6yWGp8pGBCFGezbz3kvZT3IVxNh4OthkXTt/WaGUI
         S23w6UX6v7xln+80Un3nd9Q7G2Xt0P75ca6cVutfTcrHX3GqDov/GHjP2a3SXEYdiR
         lG/xK2cgxia9me95kE9TXriHuCFvmQEtw5QujjE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 130/293] bpf: Reject indirect var_off stack access in raw mode
Date:   Mon, 20 Sep 2021 18:41:32 +0200
Message-Id: <20210920163937.714991565@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit f2bcd05ec7b839ff826d2008506ad2d2dff46a59 upstream.

It's hard to guarantee that whole memory is marked as initialized on
helper return if uninitialized stack is accessed with variable offset
since specific bounds are unknown to verifier. This may cause
uninitialized stack leaking.

Reject such an access in check_stack_boundary to prevent possible
leaking.

There are no known use-cases for indirect uninitialized stack access
with variable offset so it shouldn't break anything.

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1811,6 +1811,15 @@ static int check_stack_boundary(struct b
 		if (err)
 			return err;
 	} else {
+		/* Only initialized buffer on stack is allowed to be accessed
+		 * with variable offset. With uninitialized buffer it's hard to
+		 * guarantee that whole memory is marked as initialized on
+		 * helper return since specific bounds are unknown what may
+		 * cause uninitialized stack leaking.
+		 */
+		if (meta && meta->raw_mode)
+			meta = NULL;
+
 		min_off = reg->smin_value + reg->off;
 		max_off = reg->umax_value + reg->off;
 		err = __check_stack_boundary(env, regno, min_off, access_size,


