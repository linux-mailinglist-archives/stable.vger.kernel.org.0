Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4A96633C1
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 23:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbjAIWQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 17:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbjAIWQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 17:16:34 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721D011A2A
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 14:16:33 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4bdeb1bbeafso106102817b3.4
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 14:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UAY7ziXR1pDWT8yIaOxG4IQsxtcRX6+lmyo9rcOBFQI=;
        b=UEui1WQccphNYJS2B2rBldr80G72ZMsvoPivgTxDn/fxNbkP3rl2cZegNrl31wiaJT
         YWRA3jP5BrD3xglYqWwZOfFl/74UQK2ntqKI8UxjMlnvXsrObTXRacBD1jvkt9U0pv0N
         Rz6yX12fdD0UTvmPzwtyRL69HEjoWr6xF72eVcgjMKIwVTabZpr1OKMy01LQRmUelK34
         uoJL9SNCI4SOmZf1qKQGaD9pPn6QfObQYClE7Mk4i0jKselSNB1MRU7B3RGPs/M3WYXA
         PmQuYNpgcql7zAPOU+xV8XEM/v8in/FSMDrsPu9J1WTG35YD3VEUUbyMXCfFe8PA+/hf
         OYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UAY7ziXR1pDWT8yIaOxG4IQsxtcRX6+lmyo9rcOBFQI=;
        b=PAa9TITfr/Y92K83N0GKfVLGHRleBI+cRhKmOXkx0bP1KjvulGJf562XljUazJz/r1
         ZmcheqmDe/39HuvibJDnkA30Nr3CRCNoJ2YrsVYkYpoFRiFL3H9Z0CizxfiCrvUi8hiO
         2Ok5Zc/82i+u4uqxLjbQJcLyY8ukhikTg4tx4X90EjVfbxqC9xlayF5n6hUein7otrDf
         CAeIluqJcfBNhvOQxJ4XCQjpFePd0Y62S/+s+L/GZUb9v7994rkop7X3adfIwlw/rXBA
         6+ov6bTOgWxux4GSJcUbQaZmP+qmt0/ZlIlKGAwwCYUQxCHh4A7JomomZNPagnv7Umto
         DBZA==
X-Gm-Message-State: AFqh2kp/NVuSnQw9d/KOEybEamKAUu9UYBUHhcOwLrMMkmDzO4HshCTC
        0LLPqeE/3aGDpT/bhVfTMEXMQZ3ouCBY1fvd8zb+dA==
X-Google-Smtp-Source: AMrXdXsf7/34OOYlD8ImdQqEPY+KiIDRkgSsEo2WjPbDVqBrR8MswUATMamEBK1Wv6pIN7qPxVRK/kO82VgT8MFNA9fdcA==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:3990:5e50:b0f8:bcdd])
 (user=isaacmanjarres job=sendgmr) by 2002:a0d:d944:0:b0:46a:a08b:b5c9 with
 SMTP id b65-20020a0dd944000000b0046aa08bb5c9mr712139ywe.431.1673302592743;
 Mon, 09 Jan 2023 14:16:32 -0800 (PST)
Date:   Mon,  9 Jan 2023 14:16:22 -0800
In-Reply-To: <20230109221624.592315-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20230109221624.592315-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109221624.592315-2-isaacmanjarres@google.com>
Subject: [PATCH v1 1/2] mm/cma.c: Make kmemleak aware of all CMA regions
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        kernel-team@android.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, kmemleak tracks CMA regions that are specified through the
devicetree. However, if the global CMA region is specified through
the commandline, kmemleak will be unaware of the CMA region because
kmemleak_alloc_phys() is not invoked after memblock_reserve(). Add
the missing call to kmemleak_alloc_phys() so that all CMA regions are
tracked by kmemleak before they are freed to the page allocator in
cma_activate_area().

Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 4a978e09547a..674b7fdd563e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -318,6 +318,8 @@ int __init cma_declare_contiguous_nid(phys_addr_t base,
 			ret = -EBUSY;
 			goto err;
 		}
+
+		kmemleak_alloc_phys(base, size, 0);
 	} else {
 		phys_addr_t addr = 0;
 
-- 
2.39.0.314.g84b9a713c41-goog

