Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39D1520A9D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 03:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiEJB0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 21:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiEJB0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 21:26:00 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A3525E9;
        Mon,  9 May 2022 18:22:04 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so740257pjb.1;
        Mon, 09 May 2022 18:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UbbErnk4URiyhDcgHPYh2QePDGVMcd5mePLEmIA+Vog=;
        b=Iu2i349IulMWOLGqOZSiPtzMZi3jl8ufOkn//nui20VHCRcD/4O7hMPG6+2RMQqMkp
         ZV3OEjN8kDuAm6bfbzvclSZ0wRNAIwqBm/K5Tkt6tXDKfgA9uQO2iwJqxtE782uIb3UB
         gmuNkg2SXoE+Mu8asZ/lf4kWc3Iajp2TmALTJEqKLyWpvo1i1v+pYMujIarElkxsNe6r
         uTYT3u4otIV9UZYCsX1eCDenHa1qGdFrAoP3PtJngueGCbPAcwgOOFtQy/P9mZhCQdKC
         SGP3dBumnr/wzKwD+eVICgwBPBJTbvjKeFfdYy5mkAKjv3ItNLIr051E8UaeR1iV1nOQ
         J92w==
X-Gm-Message-State: AOAM533x9yBY61/QkVFr1P6hRBjj/VGqX5KCx8wDi8RDXMMPf4ScFYcJ
        0wYJGIYYAjtX/nzQDtx+Ncw=
X-Google-Smtp-Source: ABdhPJzcWbH06lL3gp2KEEweSQjSbSld50Abyzk7g2naibSYcflCmRKeuJA15E1QHkKb+DgHm2NXJA==
X-Received: by 2002:a17:90b:3b81:b0:1dc:32ac:a66b with SMTP id pc1-20020a17090b3b8100b001dc32aca66bmr20577182pjb.49.1652145724182;
        Mon, 09 May 2022 18:22:04 -0700 (PDT)
Received: from sultan-box.localdomain ([204.152.216.102])
        by smtp.gmail.com with ESMTPSA id be12-20020a056a001f0c00b0050dc76281basm9376105pfb.148.2022.05.09.18.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 18:22:03 -0700 (PDT)
Date:   Mon, 9 May 2022 18:22:01 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Fix races between asynchronous zspage free and
 page migration
Message-ID: <Ynm+OZrEOynVY4Ts@sultan-box.localdomain>
References: <20220509024703.243847-1-sultan@kerneltoast.com>
 <20220509170632.fec2f56ad9f640329330b9de@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509170632.fec2f56ad9f640329330b9de@linux-foundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 05:06:32PM -0700, Andrew Morton wrote:
> Why not simply lock_page() here?  The get_page() alone won't protect
> from all the dire consequences which you have identified?

Hi,

My reasoning is that if the page migrated, then we've got the last reference
to it anyway and there's no point in locking. But more importantly, we'd still
need to take migrate_read_lock() again in order to verify whether or not the
page migrated because of data races stemming from replace_sub_page(), so I don't
think there's much to gain by using lock_page(). When any of the pages in the
zspage migrates, the entire page list is reconstructed and every page's private
storage is rewritten. I had drafted another change that fixes the data races by
trimming out all of that redundant work done in replace_sub_page(), but I wanted
to keep this patch small to make it easier to review and easier to backport.

Sultan
