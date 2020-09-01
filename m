Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5427125972B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgIAQLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgIAPhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25A7205F4;
        Tue,  1 Sep 2020 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974653;
        bh=duA5OZY/skQ/JAo3h/E2BEJCdypBbG0QAcMV7CMJLRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OORzpvVxSOTREKmk+7nwe07PZ/nuX+Wq6oPs72rXGd0F5Qxj4H3ciZvPtnIpnDKBp
         j2um7ZBva1KDpvTX1JbwQm7vx6ZWR5DHb32hVLxTSMTjjIB36x3ccuGR0vNw1f9Fw9
         F0ucjpFh/5McHmdN8TMs42t+aN2CkK0LlCSespWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <fanpeng@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 043/255] mips/vdso: Fix resource leaks in genvdso.c
Date:   Tue,  1 Sep 2020 17:08:19 +0200
Message-Id: <20200901151002.813862582@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
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
index be57b832bbe0a..ccba50ec8a40e 100644
--- a/arch/mips/vdso/genvdso.c
+++ b/arch/mips/vdso/genvdso.c
@@ -122,6 +122,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (fstat(fd, &stat) != 0) {
 		fprintf(stderr, "%s: Failed to stat '%s': %s\n", program_name,
 			path, strerror(errno));
+		close(fd);
 		return NULL;
 	}
 
@@ -130,6 +131,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "%s: Failed to map '%s': %s\n", program_name,
 			path, strerror(errno));
+		close(fd);
 		return NULL;
 	}
 
@@ -139,6 +141,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0) {
 		fprintf(stderr, "%s: '%s' is not an ELF file\n", program_name,
 			path);
+		close(fd);
 		return NULL;
 	}
 
@@ -150,6 +153,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	default:
 		fprintf(stderr, "%s: '%s' has invalid ELF class\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	}
 
@@ -161,6 +165,7 @@ static void *map_vdso(const char *path, size_t *_size)
 	default:
 		fprintf(stderr, "%s: '%s' has invalid ELF data order\n",
 			program_name, path);
+		close(fd);
 		return NULL;
 	}
 
@@ -168,15 +173,18 @@ static void *map_vdso(const char *path, size_t *_size)
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
 
@@ -293,10 +301,12 @@ int main(int argc, char **argv)
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



