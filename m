Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76BF37C7AA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhELQBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237998AbhELP47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9AEA61C29;
        Wed, 12 May 2021 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833374;
        bh=CeRni4GKB62H0a4Yaj/oWpdu0wzBkcA8HQ0sgrnFasE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GY2bTkSQxJ6syJOkB315pUjsPE5QSxD6CxzkXWkvJrnkArZN7kCHdu4Yu3O+uhQqT
         cu4X1caVdoTmLh8av7+bAGPuC6x4clrxoDzYyoXyOQlAOOUxOS0nETmE8rSid/GsIi
         Ucwjp5bjXWkBJj+Qmh4opekeeIpjQ2lfEu8whiU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 124/601] x86/vdso: Use proper modifier for lens format specifier in extract()
Date:   Wed, 12 May 2021 16:43:21 +0200
Message-Id: <20210512144831.908543064@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 70c9d959226b7c5c48c119e2c1cfc1424f87b023 ]

Commit

  8382c668ce4f ("x86/vdso: Add support for exception fixup in vDSO functions")

prints length "len" which is size_t.

Compilers now complain when building on a 32-bit host:

  HOSTCC  arch/x86/entry/vdso/vdso2c
  ...
  In file included from arch/x86/entry/vdso/vdso2c.c:162:
  arch/x86/entry/vdso/vdso2c.h: In function 'extract64':
  arch/x86/entry/vdso/vdso2c.h:38:52: warning: format '%lu' expects argument of \
	type 'long unsigned int', but argument 4 has type 'size_t' {aka 'unsigned int'}

So use proper modifier (%zu) for size_t.

 [ bp: Massage commit message. ]

Fixes: 8382c668ce4f ("x86/vdso: Add support for exception fixup in vDSO functions")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lkml.kernel.org/r/20210303064357.17056-1-jslaby@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 1c7cfac7e64a..5264daa8859f 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -35,7 +35,7 @@ static void BITSFUNC(extract)(const unsigned char *data, size_t data_len,
 	if (offset + len > data_len)
 		fail("section to extract overruns input data");
 
-	fprintf(outfile, "static const unsigned char %s[%lu] = {", name, len);
+	fprintf(outfile, "static const unsigned char %s[%zu] = {", name, len);
 	BITSFUNC(copy)(outfile, data + offset, len);
 	fprintf(outfile, "\n};\n\n");
 }
-- 
2.30.2



