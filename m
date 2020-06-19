Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8BF2013DA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405510AbgFSQEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389823AbgFSPKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:10:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD8D206FA;
        Fri, 19 Jun 2020 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579425;
        bh=/747nDpUrA+HrhPyngwEof3PhSh74KiCISRw9/z8wE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXMJGMtM9CYuvx7sCXkKC4XaDKBGhhMk53kpKq1x0edOnKPWV4Zsb9hO5xpEeekIF
         TTfiu/LlsiNIJG8lrBq0g0bmc3bfHXumoipVlEGKvQ7eT+q/OddlLX02nUf8CfMOq5
         DNZlRsVLr3FsFErGGE1DX9bCxdSH/BIQvNoOVeko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaige Li <likaige@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/261] MIPS: tools: Fix resource leak in elf-entry.c
Date:   Fri, 19 Jun 2020 16:32:22 +0200
Message-Id: <20200619141656.140823802@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaige Li <likaige@loongson.cn>

[ Upstream commit f33a0b941017b9cb5a4e975af198b855b2f2b455 ]

There is a file descriptor resource leak in elf-entry.c, fix this
by adding fclose() before return and die.

Signed-off-by: Kaige Li <likaige@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/tools/elf-entry.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/mips/tools/elf-entry.c b/arch/mips/tools/elf-entry.c
index adde79ce7fc0..dbd14ff05b4c 100644
--- a/arch/mips/tools/elf-entry.c
+++ b/arch/mips/tools/elf-entry.c
@@ -51,11 +51,14 @@ int main(int argc, const char *argv[])
 	nread = fread(&hdr, 1, sizeof(hdr), file);
 	if (nread != sizeof(hdr)) {
 		perror("Unable to read input file");
+		fclose(file);
 		return EXIT_FAILURE;
 	}
 
-	if (memcmp(hdr.ehdr32.e_ident, ELFMAG, SELFMAG))
+	if (memcmp(hdr.ehdr32.e_ident, ELFMAG, SELFMAG)) {
+		fclose(file);
 		die("Input is not an ELF\n");
+	}
 
 	switch (hdr.ehdr32.e_ident[EI_CLASS]) {
 	case ELFCLASS32:
@@ -67,6 +70,7 @@ int main(int argc, const char *argv[])
 			entry = be32toh(hdr.ehdr32.e_entry);
 			break;
 		default:
+			fclose(file);
 			die("Invalid ELF encoding\n");
 		}
 
@@ -83,14 +87,17 @@ int main(int argc, const char *argv[])
 			entry = be64toh(hdr.ehdr64.e_entry);
 			break;
 		default:
+			fclose(file);
 			die("Invalid ELF encoding\n");
 		}
 		break;
 
 	default:
+		fclose(file);
 		die("Invalid ELF class\n");
 	}
 
 	printf("0x%016" PRIx64 "\n", entry);
+	fclose(file);
 	return EXIT_SUCCESS;
 }
-- 
2.25.1



