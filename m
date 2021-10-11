Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC4F429161
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244340AbhJKORo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243778AbhJKONX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213EE61350;
        Mon, 11 Oct 2021 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961055;
        bh=0JC7Hi9DfOwGRcfDRZqeJPU2hfZoHJL0faAF0oqxeQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abhSclr1ADtMJq7hIyRi/pIq7zJQJuYJA0O3E+LAvJUe26x39m1FJLI9U9b1/4HW5
         B+dVEdhbC9Sf0TmuHiHO1RnvkyUtgedytkmaRUM7dQTKYU2QrCaTs7W1K+abZnOLLd
         OYC7n/Y4q0bISE7xpLaBlQdz8kVlWbJo8nCUh1AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 146/151] x86/sev: Return an error on a returned non-zero SW_EXITINFO1[31:0]
Date:   Mon, 11 Oct 2021 15:46:58 +0200
Message-Id: <20211011134522.534816746@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 06f2ac3d4219bbbfd93d79e01966a42053084f11 upstream.

After returning from a VMGEXIT NAE event, SW_EXITINFO1[31:0] is checked
for a value of 1, which indicates an error and that SW_EXITINFO2
contains exception information. However, future versions of the GHCB
specification may define new values for SW_EXITINFO1[31:0], so really
any non-zero value should be treated as an error.

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 5.10+
Link: https://lkml.kernel.org/r/efc772af831e9e7f517f0439b13b41f56bad8784.1633063321.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-shared.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -130,6 +130,8 @@ static enum es_result sev_es_ghcb_hv_cal
 		} else {
 			ret = ES_VMM_ERROR;
 		}
+	} else if (ghcb->save.sw_exit_info_1 & 0xffffffff) {
+		ret = ES_VMM_ERROR;
 	} else {
 		ret = ES_OK;
 	}


