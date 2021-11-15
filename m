Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC59F451114
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbhKOTA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243485AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B484611F0;
        Mon, 15 Nov 2021 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000005;
        bh=g/bilKBDC6h29mvOMbtjEL+7rCtNxHcGMr1IWUxpL+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSnEUWf5hbLtUCIWGQuhpMk0E1KQVFyC7X0uGIwMQLkA7X8pU/sMSPqrwld/S2JAO
         vmd6PGftBEs75S26OPH3TtG4c+N1nA4r0CrPOIWKSSEP+RztB/CLQyUm7CkcXuAtfo
         rf379E1eqHRD4yhnoJ4sWideUBiwNzwacOCieGjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Vereshchagin <evvers@ya.ru>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 495/849] libbpf: Fix BTF header parsing checks
Date:   Mon, 15 Nov 2021 17:59:38 +0100
Message-Id: <20211115165437.032830792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit c825f5fee19caf301d9821cd79abaa734322de26 ]

Original code assumed fixed and correct BTF header length. That's not
always the case, though, so fix this bug with a proper additional check.
And use actual header length instead of sizeof(struct btf_header) in
sanity checks.

Fixes: 8a138aed4a80 ("bpf: btf: Add BTF support to libbpf")
Reported-by: Evgeny Vereshchagin <evvers@ya.ru>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211023003157.726961-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3e3ecac43ea9b..7ab9f702e72ac 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -231,13 +231,19 @@ static int btf_parse_hdr(struct btf *btf)
 		}
 		btf_bswap_hdr(hdr);
 	} else if (hdr->magic != BTF_MAGIC) {
-		pr_debug("Invalid BTF magic:%x\n", hdr->magic);
+		pr_debug("Invalid BTF magic: %x\n", hdr->magic);
 		return -EINVAL;
 	}
 
-	meta_left = btf->raw_size - sizeof(*hdr);
+	if (btf->raw_size < hdr->hdr_len) {
+		pr_debug("BTF header len %u larger than data size %u\n",
+			 hdr->hdr_len, btf->raw_size);
+		return -EINVAL;
+	}
+
+	meta_left = btf->raw_size - hdr->hdr_len;
 	if (meta_left < (long long)hdr->str_off + hdr->str_len) {
-		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
+		pr_debug("Invalid BTF total size: %u\n", btf->raw_size);
 		return -EINVAL;
 	}
 
-- 
2.33.0



