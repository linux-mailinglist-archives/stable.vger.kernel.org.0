Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1067259CA9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732637AbgIARSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728994AbgIAPNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2CEC20BED;
        Tue,  1 Sep 2020 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973234;
        bh=hHlrvVv6ZvQQkb3Q7+JMMIw0qSxNayamM1etArGofpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2e2mbUMrYagGrAMc+LFi7/4o8Va4XiWIWMc5SnGfmX6ys3PQyfWsWbjjiKziD2R/
         tTQfumSKnU3v0L1c6ng2FDZBUk+ZDAX1hBJ7U1t7Qa6qHgHIcJX0joWHj43YFT6g6U
         FVqhM7AKI+Fd+eobq/XKjgiKYxFsxIvwat6RMbMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <fanpeng@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/62] mips/vdso: Fix resource leaks in genvdso.c
Date:   Tue,  1 Sep 2020 17:10:04 +0200
Message-Id: <20200901150921.800205386@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <fanpeng@loongson.cn>

[ Upstream commit a859647b4e6bfeb192284d27d24b6a0c914cae1d ]

Close "fd" before the return of map_vdso() and close "out_file"
in main().

Signed-off-by: Peng Fan <fanpeng@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vdso/genvdso.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/vdso/genvdso.c b/arch/mips/vdso/genvdso.c
index 530a36f465ced..afcc86726448e 100644
--- a/arch/mips/vdso/genvdso.c
+++ b/arch/mips/vdso/genvdso.c
@@ -126,6 +126,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (fstat(fd, &stat) != 0) {
 		fprintf(stderr, "%s: Failed to stat '%s': %s\n", program_name,
 			path, strerror(errno));
+		close(fd);
 		return NULL;
 	}
 
@@ -134,6 +135,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "%s: Failed to map '%s': %s\n", program_name,
 			path, strerror(errno));
+		close(fd);
 		return NULL;
 	}
 
@@ -143,6 +145,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0) {
 		fprintf(stderr, "%s: '%s' is not an ELF file\n", program_name,
 			path);
+		close(fd);
 		return NULL;
 	}
 
@@ -154,6 +157,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	default:
 		fprintf(stderr, "%s: '%s' has invalid ELF class\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	}
 
@@ -165,6 +169,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	default:
 		fprintf(stderr, "%s: '%s' has invalid ELF data order\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	}
 
@@ -172,15 +177,18 @@ static void *map_vdso(const char *path, size_t *_size)
 		fprintf(stderr,
 			"%s: '%s' has invalid ELF machine (expected EM_MIPS)\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	} else if (swap_uint16(ehdr->e_type) != ET_DYN) {
 		fprintf(stderr,
 			"%s: '%s' has invalid ELF type (expected ET_DYN)\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	}
 
 	*_size = stat.st_size;
+	close(fd);
 	return addr;
 }
 
@@ -284,10 +292,12 @@ int main(int argc, char **argv)
 	/* Calculate and write symbol offsets to <output file> */
 	if (!get_symbols(dbg_vdso_path, dbg_vdso)) {
 		unlink(out_path);
+		fclose(out_file);
 		return EXIT_FAILURE;
 	}
 
 	fprintf(out_file, "};\n");
+	fclose(out_file);
 
 	return EXIT_SUCCESS;
 }
-- 
2.25.1



