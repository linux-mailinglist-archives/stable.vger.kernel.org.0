Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111DB300547
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbhAVOYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbhAVOXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02A2523B04;
        Fri, 22 Jan 2021 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325086;
        bh=lZZi3zTbVDlWhX8pOGBIxdy2FlKVgpO/y8yhoXFbqbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6DwR/6eOJUlMeUQFBEjx10W6G4eufuaw3Y8Py8k7xnStn03yoaJpi4H7z6vFl9O3
         67qmx5sQ8Srn36O+PVBN5/ef8Vy8nsfzphfv4u4CiOpT94crf6moDsiyUgeFWCtDPi
         tV26dApps61ACSc6U0EmTdN6texm57thlRnpvotM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mircea Cirjaliu <mcirjaliu@bitdefender.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mauricio Vasquez <mauriciovasquezbernal@gmail.com>
Subject: [PATCH 5.10 10/43] bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback
Date:   Fri, 22 Jan 2021 15:12:26 +0100
Message-Id: <20210122135736.063338583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mircea Cirjaliu <mcirjaliu@bitdefender.com>

commit 301a33d51880619d0c5a581b5a48d3a5248fa84b upstream.

I assume this was obtained by copy/paste. Point it to bpf_map_peek_elem()
instead of bpf_map_pop_elem(). In practice it may have been less likely
hit when under JIT given shielded via 84430d4232c3 ("bpf, verifier: avoid
retpoline for map push/pop/peek operation").

Fixes: f1a2e44a3aec ("bpf: add queue and stack maps")
Signed-off-by: Mircea Cirjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mauricio Vasquez <mauriciovasquezbernal@gmail.com>
Link: https://lore.kernel.org/bpf/AM7PR02MB6082663DFDCCE8DA7A6DD6B1BBA30@AM7PR02MB6082.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -108,7 +108,7 @@ BPF_CALL_2(bpf_map_peek_elem, struct bpf
 }
 
 const struct bpf_func_proto bpf_map_peek_elem_proto = {
-	.func		= bpf_map_pop_elem,
+	.func		= bpf_map_peek_elem,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,


