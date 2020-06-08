Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38641F24B3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgFHXVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbgFHXVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A67920899;
        Mon,  8 Jun 2020 23:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658513;
        bh=/747nDpUrA+HrhPyngwEof3PhSh74KiCISRw9/z8wE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vz337WBolvU5zSAitlAIhtWfro20ELN4uvwfNqEd7IBE1LjBG9g6Y/IITeSZq9Qzl
         lKHhZos9y2hdshDZlNLslJOJ++PsVAIBit1AfNgp24T5mvJQdEYPr7kDurdfd3P5QZ
         0cJAuQuOk0v4FV3SLoq1sNEmMCmsts7A6wT40DAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kaige Li <likaige@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 142/175] MIPS: tools: Fix resource leak in elf-entry.c
Date:   Mon,  8 Jun 2020 19:18:15 -0400
Message-Id: <20200608231848.3366970-142-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

