Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B030534B12
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346549AbiEZIBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 04:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346548AbiEZIBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 04:01:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAAE1137
        for <stable@vger.kernel.org>; Thu, 26 May 2022 01:01:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso1129754pjg.0
        for <stable@vger.kernel.org>; Thu, 26 May 2022 01:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cPBo1/z66AxJUif/4bPiA1dLl6Egi0hfAP6GvoU1sV0=;
        b=6NDxIR+6uUjB7dCwGwcfqdek2+lKlTwfSd4MrrZtOi2+ClUTwfkElbtFD8Eis/0Y0K
         4yzinANtUEfNW6aZ5PgGrCpUDiKmjpMuxDDBuBoNx8J+Ltp630gvBrHk6vVEHJODIJqT
         H2C/fYRd3/28omWbOUzOTnBOAqisf5q8P8Y/ff38fXBVnD4uQD/pu+t/NpvE0qOca6fs
         87xzlWTEWFqJeIeqSbDGWHVKqe55zklRpv5o1vKs3+qVQ1s0PyaJIInHW2j4r6Nl7LIZ
         AqFFcCAYF6n1O5RWdxeTBQYS3DQrroQd6sGgvQCswwxKGSPNyTvhFHu6XWONMl6wHyJC
         IhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cPBo1/z66AxJUif/4bPiA1dLl6Egi0hfAP6GvoU1sV0=;
        b=drfhNkq9YWgbKwujl85L7E1NioHmD3CQv7w1vTlH+wzzmmkGsoIMsSxMJg2I1EFosk
         oG6dBx4Ikj5fOq10c7s4X0loAXG8YgBhGpgtNNoCn1yGiu1YJOpFN5cQzfyRn7dh7+8t
         dNEO3lnLu2DFbMs00/mFiaIHEDrp0hSsOGqXt1SdtkdhJaKuXbir3IwJQ1mdeu/g7TFu
         7rCd59rs32pMVWqOWu9zQ9OcAskx8j28W3E9uH16eXu1Fh/YjLvyVYgdEHuHMd5zmGwU
         oT3aEWLgCGo01K+CG4Jd0iC1icBE+zXAceiNsSQDHieLt7Whb7RimTUcKPjutuPjgoV6
         Xuhw==
X-Gm-Message-State: AOAM531KtvgtU15pxb6tm8DrFwmNxuAa20ragWO8bG++k/2T7iFeaEvg
        VwBjanY0KmNNZjLPEleNXEOPTg==
X-Google-Smtp-Source: ABdhPJwDoYXHfQff5yRn4D7OgwdsNB7fZai9C6375HvH4oaizoEl5HaKAQtrJ59CkBsSddya7lY9xw==
X-Received: by 2002:a17:903:240b:b0:14b:1100:aebc with SMTP id e11-20020a170903240b00b0014b1100aebcmr37188416plo.133.1653552074176;
        Thu, 26 May 2022 01:01:14 -0700 (PDT)
Received: from localhost ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id e14-20020a170903240e00b0015e8d4eb1fasm806650plo.68.2022.05.26.01.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:01:13 -0700 (PDT)
Date:   Thu, 26 May 2022 16:01:10 +0800
From:   Muchun Song <songmuchun@bytedance.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix huge_pmd_unshare address update
Message-ID: <Yo8zxk0kCRikYk0x@FVFYT0MHHV2J.googleapis.com>
References: <20220524205003.126184-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524205003.126184-1-mike.kravetz@oracle.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 01:50:03PM -0700, Mike Kravetz wrote:
> The routine huge_pmd_unshare is passed a pointer to an address
> associated with an area which may be unshared.  If unshare is successful
> this address is updated to 'optimize' callers iterating over huge page
> addresses.  For the optimization to work correctly, address should be
> updated to the last huge page in the unmapped/unshared area.  However,
> in the common case where the passed address is PUD_SIZE aligned, the
> address is incorrectly updated to the address of the preceding huge
> page.  That wastes CPU cycles as the unmapped/unshared range is scanned
> twice.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 39dde65c9940 ("shared page table for hugetlb page")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
