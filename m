Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FD2341C6A
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhCSMUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhCSMU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AB8664FA1;
        Fri, 19 Mar 2021 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156414;
        bh=iNLNdrtmsO6DnAhgiLpQNILkfvso9NVdSQ4vT0zKqQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNSX46Jxys4in4WRVBT0zW+napGdU4eaEcqEquhu/j3Gk9tgrQLUpWkIYlDNs0Jnk
         Mgrtle8OufmhkNznYEapewWD+9RYi0dyP5EwIR1glFgyUZkl1wLO7cU5xpayqjGRVy
         mI1ZnX5/DwWgaxz9Eb10LJ8rkovW5k1RjZ4yqInA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 06/13] bpf: Add sanity check for upper ptr_limit
Date:   Fri, 19 Mar 2021 13:19:03 +0100
Message-Id: <20210319121745.310254598@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
References: <20210319121745.112612545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit 1b1597e64e1a610c7a96710fc4717158e98a08b3 upstream.

Given we know the max possible value of ptr_limit at the time of retrieving
the latter, add basic assertions, so that the verifier can bail out if
anything looks odd and reject the program. Nothing triggered this so far,
but it also does not hurt to have these.

Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5333,10 +5333,14 @@ static int retrieve_ptr_limit(const stru
 {
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off;
+	u32 off, max;
 
 	switch (ptr_reg->type) {
 	case PTR_TO_STACK:
+		/* Offset 0 is out-of-bounds, but acceptable start for the
+		 * left direction, see BPF_REG_FP.
+		 */
+		max = MAX_BPF_STACK + mask_to_left;
 		/* Indirect variable offset stack access is prohibited in
 		 * unprivileged mode so it's not handled here.
 		 */
@@ -5345,15 +5349,16 @@ static int retrieve_ptr_limit(const stru
 			*ptr_limit = MAX_BPF_STACK + off;
 		else
 			*ptr_limit = -off - 1;
-		return 0;
+		return *ptr_limit >= max ? -ERANGE : 0;
 	case PTR_TO_MAP_VALUE:
+		max = ptr_reg->map_ptr->value_size;
 		if (mask_to_left) {
 			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
 			*ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
 		}
-		return 0;
+		return *ptr_limit >= max ? -ERANGE : 0;
 	default:
 		return -EINVAL;
 	}


