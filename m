Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7541628BA7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 22:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiKNV4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 16:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiKNV4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 16:56:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E498410FDF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668462902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qpc2eQF4OVRCR9vIz7961ylczQfdMl7P3OUcWUSapU0=;
        b=C7Qk94be0dmNlQyoSBceypk7d3a56qScObS8ziYRski97UKEvSY7qqHCdfA2s80ckOXQf5
        FgoqKPRQyuRXoArU6xC1tcM9gpOI+6Of/LeK0htcuVuzoTdce948+Egm0A27X8vawmySx/
        ab2aEs6CFmyLSwN8S4jwkDJm4BccNak=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-m2OpyNWmMYeQxCPSN4MvNA-1; Mon, 14 Nov 2022 16:54:59 -0500
X-MC-Unique: m2OpyNWmMYeQxCPSN4MvNA-1
Received: by mail-qv1-f72.google.com with SMTP id 71-20020a0c804d000000b004b2fb260447so9303853qva.10
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qpc2eQF4OVRCR9vIz7961ylczQfdMl7P3OUcWUSapU0=;
        b=b6TvK6gnF8QPAkrvFMcU7U+SjgMrmPFCxoPGjYBqxmoxXCak3Dt4qjRrp14maraBtW
         /e7ehr1vCIYLchSC//HiFbvimxKY8u89BWH0DU4oVmCRvM+4X0ybcwxMLO1j+RuBe0A4
         9s76JptRe2v+om+BmeOUA+EzZbsLsiF9DP8LO0U4UF5SjO4Gbrp/I0FtVLTY1C7D8BIg
         D24AnWch4NL1kkBduavYWltJk9Pg7RFeAQxVyEFK6dYzsMs4VoaKROb/4r60/kbBZuGG
         hY24ymm4c4y7Y/pVzYEPAtfAlJKGH4/2qcrpQGC2ZfaXwV9bsHuNmtEta5Uehdy++57d
         fsRQ==
X-Gm-Message-State: ANoB5pk5KHHUuXVvkDe0wlP9jV1AiYkm9rGBewxfKSLN1oE84H8lgXWS
        qMiLS7cpFSe1y2ZyGFkC1JVUone9U6kLq14Td9/CdZ3HbD20yB7Z+S3XD1x9qOFcLe4mzMJzHOK
        bc8u8vNfmuZnmEpHr
X-Received: by 2002:a05:6214:1902:b0:4a4:474a:1394 with SMTP id er2-20020a056214190200b004a4474a1394mr14177480qvb.36.1668462898907;
        Mon, 14 Nov 2022 13:54:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4JgH34ZSNeRxluqCoega8kEsCXijBbz2npC1p8GEG2x4oKXtEevNQk4JgOUn038jyPFgODag==
X-Received: by 2002:a05:6214:1902:b0:4a4:474a:1394 with SMTP id er2-20020a056214190200b004a4474a1394mr14177451qvb.36.1668462898651;
        Mon, 14 Nov 2022 13:54:58 -0800 (PST)
Received: from ?IPv6:2600:4040:5c6c:9200::feb? ([2600:4040:5c6c:9200::feb])
        by smtp.gmail.com with ESMTPSA id i19-20020a05620a249300b006fb38ff190bsm7023557qkn.34.2022.11.14.13.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 13:54:57 -0800 (PST)
Message-ID: <4482e7de979cc6673162b7aac0fcbfddb5d2d906.camel@redhat.com>
Subject: Re: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
From:   Lyude Paul <lyude@redhat.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Cc:     "Wentland, Harry" <Harry.Wentland@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Li, Roman" <Roman.Li@amd.com>, "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        "Hung, Alex" <Alex.Hung@amd.com>,
        "Francis, David" <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Liu, Wenjing" <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 14 Nov 2022 16:54:55 -0500
In-Reply-To: <CO6PR12MB5489E3850FE3C9FBDA7BAC29FC3E9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20221104235926.302883-1-lyude@redhat.com>
         <20221104235926.302883-2-lyude@redhat.com>
         <CO6PR12MB5489E3850FE3C9FBDA7BAC29FC3E9@CO6PR12MB5489.namprd12.prod.outlook.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-11-09 at 09:48 +0000, Lin, Wayne wrote:
> >   	}
> > -	if (!drm_dp_mst_atomic_check(state) && !debugfs_overwrite) {
> > +	ret = drm_dp_mst_atomic_check(state);
> > +	if (ret == 0 && !debugfs_overwrite) {
> >   		set_dsc_configs_from_fairness_vars(params, vars, count,
> > k);
> > -		return true;
> > +		return 0;
> > +	} else if (ret == -EDEADLK) {
> > +		return ret;
> 
> I think we should return here whenever there is an error. Not just for
> EDEADLK case. 

Are we sure about this one? I think we may actually want to make this so it
returns on ret != -ENOSPC, since we want the function to continue if there's
no space in the atomic state available so it can try recomputing things with
compression enabled. On ret == 0 it should return early without doing
compression, and on ret == -ENOSPC it should just continue the function from
there

-- 
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

