Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0989344467
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCVM7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhCVM4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:56:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184B5619BC;
        Mon, 22 Mar 2021 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417309;
        bh=EDHo5EtwE/zUEs+4jbe7lpalNHcGSxojzeaT9hy/QTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rtrO0+gOllaXjh6c9YfgNMrT7pnqeTJfJsaw5sGOCBA3uFm0B17oAXvd71VTS9OI
         SxrQK7mx3GUrV4zVazmb3VaRy37WQyd4EtzNQMldhEwP5B97hEtFsfHtNwui3nxcBh
         2vdaWaID+mkcBbGv1w1IFmY9DDbkk8jA7gizNhmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 06/43] bpf: Add sanity check for upper ptr_limit
Date:   Mon, 22 Mar 2021 13:28:47 +0100
Message-Id: <20210322121920.260131229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
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
@@ -2029,24 +2029,29 @@ static int retrieve_ptr_limit(const stru
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
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
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


