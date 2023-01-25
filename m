Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEE367B916
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbjAYSOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235695AbjAYSOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:14:41 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D9147ECC
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:14:40 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m12so2535598edq.5
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ezfgQvWoMwYi/wrVPbQBarXLnM5cDi1r4h1toUfXH6c=;
        b=cGn+xBZGLUGvEEQSQEj8q7PiKeDnCb14P3MOhmCCN3HhQSOmIsRjhNBB9kLQOgJPtI
         GZ3CutDFj51OwAyR8zxU2JURtxQbRtWIqvZu3wP4Di9u47Vcx6QSh1pJH4SxN8OQBniG
         YcphD1DbWFqQSMYnIEjB7qrG4s9fhM/3URZsILyle9KPNXUW/Ie1SfVlA4MevrKHCkm3
         p3YkCb9f8dmb7utnp3xYktANPPhrv9eJtYKT+P9YEWUI2htA35cEjMp5ImYJvzxExC2F
         o3R+nMif1e2BDalQApSuF2LB8IhPhh/pLT/Yj9PWnW5F7d/JKd2ZEE5cmwiwDGVKoD+G
         0iKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezfgQvWoMwYi/wrVPbQBarXLnM5cDi1r4h1toUfXH6c=;
        b=3dI4ocwgqO6CYebAn3xmfLiNeyLIysGxcWGbz4gfQlmIned/2zkbHpyPTXrpFwbqjg
         lT4/VboqgYs+ZLnOSJwrTM2Q6thkJ3FP9GVnTfTKuhbluvO0huzInAW7+8cdymg4zUkI
         K+wdaCh0C8zqdD3SV9w/l32heHvsBfm9TPULUVvZPIZnLxClDhEE4Wmqd3N++T+/Dm/h
         dzrkb4vdurSsiGHxiKtS9Ot2PGLiK/0zeR4l7rXuNcUoDQg5KOY27+oDHSC3fAvlM/VD
         uCipmW2pAgk/HK86luECqJ5t0N/OVWXcyexc7cN/XgufyPCuf4MW26KLgU2RfFD6Xege
         Ky1g==
X-Gm-Message-State: AFqh2kq8/jKbtjcB1R4FmwWH4svjn9NL4EPBE2XP4XoCaoodXSdoYpo2
        dygrveHt40/bcjlOookeSPzqGTvEDDHi0SldmWMRvQ==
X-Google-Smtp-Source: AMrXdXuT6xMFHJVZ5QLk/+wQjDgjKjQNWw0t82BBGNsYvY9n1cbbZqP0y0Ny/YOsHABz+zn+gawW9hmxBLs+nRoPRDk=
X-Received: by 2002:a05:6402:2054:b0:498:216:ee4c with SMTP id
 bc20-20020a056402205400b004980216ee4cmr4403222edb.29.1674670478499; Wed, 25
 Jan 2023 10:14:38 -0800 (PST)
MIME-Version: 1.0
References: <20230125015738.912924-2-zokeefe@google.com> <202301252110.hFYRsbrm-lkp@intel.com>
In-Reply-To: <202301252110.hFYRsbrm-lkp@intel.com>
From:   "Zach O'Keefe" <zokeefe@google.com>
Date:   Wed, 25 Jan 2023 10:14:01 -0800
Message-ID: <CAAa6QmTjn-Lnw9Sj80RCaCWmqehDSdRJVp0923UUTD68jMqoDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/MADV_COLLAPSE: catch !none !huge !bad pmd lookups
To:     kernel test robot <lkp@intel.com>
Cc:     linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Yang Shi <shy828301@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apologies here; shouldn't have overlooked the 4 line change. Will
follow-up with a v2 here in a second.
