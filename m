Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98C607DFA
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJUR4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 13:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJUR4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 13:56:37 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F1B26551F;
        Fri, 21 Oct 2022 10:56:36 -0700 (PDT)
Received: by mail-qk1-f170.google.com with SMTP id t25so2527144qkm.2;
        Fri, 21 Oct 2022 10:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fPM8TKWkSeLqibh2gUQQQJJ62C2z9/V7mCcM5ffseGA=;
        b=E/TT4g9vzADOh0eObO52uw8qMBxC/bLr7aLszGzr4wsIV0FC1fUUrRyJfb2u7Y9F30
         jcsXZpbhswI/rzKTZNALWFKW2esNjeKRnZRPP07YardnHZUSp/8RcTb3QTEl8dobL2Kf
         /a8ez2OGT2Id2SbBxo0rVoeRknIs7PM4IGLpiELZMColewhtWPNL+3tX5H9isZzyc2lg
         q4VytRBx6MCgCJKnmg+f4gh/JqkvcHZKJJASTtVC9aufwNpVP7jSlYesYES9L1YGrqTl
         R/cU8xbzs/LXd8qQcdNfYUVLZ6HpkLVyl44c//fOtXR5AQ3ado5FPJcvuNP40V6Q5Im3
         l5ow==
X-Gm-Message-State: ACrzQf1GWsY46Cb9j7zCwuv3wpmedpWBr7U8Xtsm/uJvUuWjTqJKzVTk
        9sil8aER7rMnjv1t8VgwT5CJOTIa8UjN8cXdW9Be1X33
X-Google-Smtp-Source: AMsMyM4Vt3ZrjuCWRNdfpBz4Z4erUW6gWVRGf1sCjzxago2tQ+T/Zjocx2cLM1a9t7oqLSOgGxTJmNdTg1oZaPwgClY=
X-Received: by 2002:a05:620a:450c:b0:6ee:af91:60b2 with SMTP id
 t12-20020a05620a450c00b006eeaf9160b2mr15639967qkp.480.1666374995779; Fri, 21
 Oct 2022 10:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 21 Oct 2022 19:56:24 +0200
Message-ID: <CAJZ5v0iGz0Z=WFyStEB4Dj2fpjyy9r6aBYK1SKjBcayhGa=sWA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: NUMA: Add CXL CFMWS 'nodes' to the possible nodes set
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        Alison Schofield <alison.schofield@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 1:55 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> The ACPI CEDT.CFMWS indicates a range of possible address where new CXL
> regions can appear. Each range is associated with a QTG id (QoS
> Throttling Group id). For each range + QTG pair that is not covered by a proximity
> domain in the SRAT, Linux creates a new NUMA node. However, the commit
> that added the new ranges missed updating the node_possible mask which
> causes memory_group_register() to fail. Add the new nodes to the
> nodes_possible mask.
>
> Cc: <stable@vger.kernel.org>
> Fixes: fd49f99c1809 ("ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT")
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Tested-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Rafael, I can take this through the CXL tree with some other pending
> fixes.

Sure.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

>  drivers/acpi/numa/srat.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
> index 3b818ab186be..1f4fc5f8a819 100644
> --- a/drivers/acpi/numa/srat.c
> +++ b/drivers/acpi/numa/srat.c
> @@ -327,6 +327,7 @@ static int __init acpi_parse_cfmws(union acpi_subtable_headers *header,
>                 pr_warn("ACPI NUMA: Failed to add memblk for CFMWS node %d [mem %#llx-%#llx]\n",
>                         node, start, end);
>         }
> +       node_set(node, numa_nodes_parsed);
>
>         /* Set the next available fake_pxm value */
>         (*fake_pxm)++;
>
