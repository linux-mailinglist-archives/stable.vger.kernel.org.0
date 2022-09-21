Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113635BF932
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIUI2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIUI1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:27:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7055B8307A;
        Wed, 21 Sep 2022 01:27:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lc7so12041924ejb.0;
        Wed, 21 Sep 2022 01:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=7heNxsmzeCJMCboW48gJRU3lnBaNyKK1ZKFS0gVn9ig=;
        b=arZwDiUxQVi/fGwGijH/ZarWMhsOVcu0w3XVgeXboS5WqHpRqZG9NuGCasNoSXgHmC
         /+dK1wqAXgKr8YJWCb1rEHU69VA+IvZzyBCqzBDob+P16PpsefR/vagip1beUkE2OLoc
         z6WeCQFZ1ToLfjpg9EqTA25iFJRebWUKO7aoIRCOqA6Y5T6ATTptL7akffSQOHfnV6Qb
         kYmq5x9bfZMXhOWkilm17aBup2nPqArAykkoJc0FS03OxCcdFGnPfJe94NmrNEilDL/9
         e6KOsZGCl1ZLk5ToIwV0lhIuecRHBQRnSzk3cT87TaClgvFIoiEfCYyf2Lf1IO/2bNHH
         cZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=7heNxsmzeCJMCboW48gJRU3lnBaNyKK1ZKFS0gVn9ig=;
        b=RGV4uJo1kNvIh5UpkK3CFuTdBZLWACRmzndHE8Fq8svaUVcRvPD+UQMFwWVkYorvPF
         ELGQ45G8ltz/m3/NdLuirGp1LTPBXF08ZbaDuHi2JewDx8morumBfYowjrWIMKDTBirg
         VEB/Rb3cDgyWjdEP5GCWD5kvwvDihmdm/sdam3r1Guc9qMgauY4VFOHO/5BKYDNvRqPf
         macy/apqAjo0+pZX0AN7hhXCho8Xcx1FWMr3RHBwHpuDBTE70N3PjKqzmXnDY9pAsQvi
         dd7AM1zfcMwBs06XmGYKzeUlm1Vrif5MvuYXIcybURqsLctp8+8BXF12DEpPYkpOEkxW
         8SOA==
X-Gm-Message-State: ACrzQf3ja7FDtqdZWaAY3XmAkkXQ1Z5p+fisMxQIjNhjtEqyvA86ig7A
        tITj8kyot7nLqaRKdBG3KOZAwPXQTrs=
X-Google-Smtp-Source: AMsMyM7I/KS1GvOaN+r07SgivcB9KHzApPg7eWvpRorPUgnciuXPb8/PrYFEGBxgN42fIT1LmhqMYg==
X-Received: by 2002:a17:906:4548:b0:77d:3c16:2e9b with SMTP id s8-20020a170906454800b0077d3c162e9bmr20331873ejq.757.1663748860419;
        Wed, 21 Sep 2022 01:27:40 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id b1-20020a1709063ca100b0077fbef08212sm1015635ejh.22.2022.09.21.01.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 01:27:39 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH bpf] bpf: Gate dynptr API behind CAP_BPF
Date:   Wed, 21 Sep 2022 10:27:38 +0200
Message-Id: <20220921082738.7938-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2632; i=memxor@gmail.com; h=from:subject; bh=DCkrIGzoXk6j2Jta3oGROnjii8WwNZfXOBF07njClLc=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBjKsqJf/tZiyCRF/E4lP3QXyRX4+O9TJAmmqJUL/Si ftl9+t+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYyrKiQAKCRBM4MiGSL8RyjlmD/ sHY0q/AkIs/YYZqRk3Uu2E1qJ2RRe1amJ2+cI8/EiPIw2dm4wKwkkJJJxBiKUekK2kHIc47U2xW/w2 OdZ0g/a1j4ke+05+DM3mE9N9vbL5JYSn8CIx4WywLKpT6HKCsFnr43B0DCiAXBLM9+6xCpFA/Bu+ww GHWb/khTEZ9ashht8G61U81Kh8plRbrexxjzbRIftlkSg5z+au7fsOeICzA88Oj098eQFH8LmaaKUT AMRNKl2YzIVnsobA1uFJdqxeusDKH6E0gRQR1beXVNIxDjuNLrivXQhFZ+K7mxh3wDmFkKs/r8xdvV gZcshoQhRRLErX0aXXx+QeplhS/ov+5DhVNEy0/Hves9SDEMVuAKGI1Fu9/o8RECBtAw3boB6SAk3r BOOnxZXK+qJDsULvKIys6NMKsBD+j6POnWQoopMF0GxGRRUXCYz8pYU+gQw8rw5V5MraovuBOOtkhe qRyWU/soOdQ3IUPFV03T68pOkpXqFn0mWts3cRgRYoveknI+V4yQ372d7yTZnPbGVS4CmMRWkhyEg4 ALOVzInIawfASh08H+1oekxNdRKpKT73xdJiZxQKh4qmHDgXp7XdTx/3SRb1MIAWrV5XkRsy/wBuT8 pezthitU+rVrjdPddwWaeR8C3S5LAiBh0Yd4XGH6lW3YANj7SSf3zmqazKmg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This has been enabled for unprivileged programs for only one kernel
release, hence the expected annoyances due to this move are low. Users
using ringbuf can stick to non-dynptr APIs. The actual use cases dynptr
is meant to serve may not make sense in unprivileged BPF programs.

Hence, gate these helpers behind CAP_BPF and limit use to privileged
BPF programs.

Fixes: 263ae152e962 ("bpf: Add bpf_dynptr_from_mem for local dynptrs")
Fixes: bc34dee65a65 ("bpf: Dynptr support for ring buffers")
Fixes: 13bbbfbea759 ("bpf: Add bpf_dynptr_read and bpf_dynptr_write")
Fixes: 34d4ef5775f7 ("bpf: Add dynptr data slices")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/helpers.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 41aeaf3862ec..f57a08b6dddb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1607,26 +1607,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ringbuf_discard_proto;
 	case BPF_FUNC_ringbuf_query:
 		return &bpf_ringbuf_query_proto;
-	case BPF_FUNC_ringbuf_reserve_dynptr:
-		return &bpf_ringbuf_reserve_dynptr_proto;
-	case BPF_FUNC_ringbuf_submit_dynptr:
-		return &bpf_ringbuf_submit_dynptr_proto;
-	case BPF_FUNC_ringbuf_discard_dynptr:
-		return &bpf_ringbuf_discard_dynptr_proto;
 	case BPF_FUNC_strncmp:
 		return &bpf_strncmp_proto;
 	case BPF_FUNC_strtol:
 		return &bpf_strtol_proto;
 	case BPF_FUNC_strtoul:
 		return &bpf_strtoul_proto;
-	case BPF_FUNC_dynptr_from_mem:
-		return &bpf_dynptr_from_mem_proto;
-	case BPF_FUNC_dynptr_read:
-		return &bpf_dynptr_read_proto;
-	case BPF_FUNC_dynptr_write:
-		return &bpf_dynptr_write_proto;
-	case BPF_FUNC_dynptr_data:
-		return &bpf_dynptr_data_proto;
 	default:
 		break;
 	}
@@ -1659,6 +1645,20 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_for_each_map_elem_proto;
 	case BPF_FUNC_loop:
 		return &bpf_loop_proto;
+	case BPF_FUNC_ringbuf_reserve_dynptr:
+		return &bpf_ringbuf_reserve_dynptr_proto;
+	case BPF_FUNC_ringbuf_submit_dynptr:
+		return &bpf_ringbuf_submit_dynptr_proto;
+	case BPF_FUNC_ringbuf_discard_dynptr:
+		return &bpf_ringbuf_discard_dynptr_proto;
+	case BPF_FUNC_dynptr_from_mem:
+		return &bpf_dynptr_from_mem_proto;
+	case BPF_FUNC_dynptr_read:
+		return &bpf_dynptr_read_proto;
+	case BPF_FUNC_dynptr_write:
+		return &bpf_dynptr_write_proto;
+	case BPF_FUNC_dynptr_data:
+		return &bpf_dynptr_data_proto;
 	default:
 		break;
 	}
--
2.34.1

