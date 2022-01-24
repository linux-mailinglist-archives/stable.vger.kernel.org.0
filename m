Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280C749A4D2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371969AbiAYAKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363971AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A95C05A1BA;
        Mon, 24 Jan 2022 13:40:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D52D6150F;
        Mon, 24 Jan 2022 21:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFADC340E4;
        Mon, 24 Jan 2022 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060406;
        bh=GEPTA5WbQg+7Raj5vrdh/6V20f+eelTVgqL11f2YC6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2MXvWyqMgkcDVmujtTsxFAm7n/OBwPo7Em9DpzIhJqnmsRaxpebtB5lPPJ5yVCMB
         Ikzup0xjtQ1zMsM15oT/c7d7OGwaXiHxpMx0DQ0p85bIGsePEzXvKQa+xEGQxMCaFI
         WabjAlsgXeFipsutH/vSI8HZtPMf7qA/HLxxcV9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH 5.16 0936/1039] libbpf: Remove deprecation attribute from struct bpf_prog_prep_result
Date:   Mon, 24 Jan 2022 19:45:25 +0100
Message-Id: <20220124184156.752157099@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

commit 5c5edcdebfcf3a95257b0d8ef27a60af0e0ea03a upstream.

This deprecation annotation has no effect because for struct deprecation
attribute has to be declared after struct definition. But instead of
moving it to the end of struct definition, remove it. When deprecation
will go in effect at libbpf v0.7, this deprecation attribute will cause
libbpf's own source code compilation to trigger deprecation warnings,
which is unavoidable because libbpf still has to support that API.

So keep deprecation of APIs, but don't mark structs used in API as
deprecated.

Fixes: e21d585cb3db ("libbpf: Deprecate multi-instance bpf_program APIs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/bpf/20211103220845.2676888-8-andrii@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/libbpf.h |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -431,7 +431,6 @@ bpf_program__attach_iter(const struct bp
  * one instance. In this case bpf_program__fd(prog) is equal to
  * bpf_program__nth_fd(prog, 0).
  */
-LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_program__insns() for getting bpf_program instructions")
 struct bpf_prog_prep_result {
 	/*
 	 * If not NULL, load new instruction array.


