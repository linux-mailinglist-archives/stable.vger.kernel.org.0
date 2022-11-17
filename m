Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1846162DDCE
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbiKQOTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 09:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiKQOTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 09:19:31 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93ADD10079
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 06:19:30 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bp15so2977712lfb.13
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 06:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D3x133dVtwVv7jvx8g97kW4FBOvvKkB/v2oc16Tf4lc=;
        b=HrVH8yqh59n941IfjY8F2X3AvLLvdAiPmJ+LjuOQJSHpEVGtdgWDTTcoEKtqXZjfcH
         BJYvIAQKdWMlCETZNgkGvK2ciql3SNLG9lNHBolWfrYQlE1P534aKrS/+HPFui6P5pnu
         +2OW6S+9MkUOpfawuNT4zCy+QFH/k7z27DPt2l8ozLtQ1sEjJcQE+t/YYzx0J3XW1VR1
         26P7roYiX5qFLu//qxeLGFlXXH/0B/JYGVMXtNsmJekqdxNjeq9hIGghT+h3LNaxKFrA
         oA48gB3qhT6DzyyqhzUmjAOKTkQJSu2AwoieLsRXVR3gzJv8IOtsNUuO8cFjA+yU+Vrk
         Ph9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D3x133dVtwVv7jvx8g97kW4FBOvvKkB/v2oc16Tf4lc=;
        b=neM605ji/V1w6xzQVPDcIM9/EgWhu2bHwLCRWe7iwr3rvC7LWFH5u87AXWMjSePnOO
         8HLLgUASuS/PMRsEsb906luaeqla1+aZbUsG1eNYG27AmB4/ksx6tlrXOMCOB4AZ/Q24
         I3PZ8yNTCxk670OcIpVHjofs95KqD3nuSoOUKDDxCJpNoUXOuEyMysNItaQyB7hMLANQ
         TZnBu2OvSwm/0QLq/Emlu+QJftQU1kWrCaeMoVeBLTUPAfDDqC7SNly3NIX/pUQaJ1Dc
         5tGBBQC7pEha767o95swYGqKXVuNgUM/vDATPCD8oOUeGejUwyRRmKoUjmlSmESPAl3j
         Ur4w==
X-Gm-Message-State: ANoB5plMaIFHyiXny8hmJuipSVCiYGRodrbVFdMhUIaKohVcjS1J8Qf9
        3mgpJmUcOVRJNnqg+YHoWsZdKxYCTaAJrouj/oqc6Q==
X-Google-Smtp-Source: AA0mqf5kzXHbPe7bzUd65hhZ3QFU51HYKZ9rSJYlc9u1KutxM95JyTZBnpvd7beNyf60khWyXGnqT9IfKSkQ9ixHWIo=
X-Received: by 2002:a05:6512:3a3:b0:4b1:11a3:d1b with SMTP id
 v3-20020a05651203a300b004b111a30d1bmr1092769lfp.291.1668694768789; Thu, 17
 Nov 2022 06:19:28 -0800 (PST)
MIME-Version: 1.0
References: <20221116175558.2373112-1-pgonda@google.com> <3e50c258-8732-088c-d9d8-dfaae82213f0@amd.com>
In-Reply-To: <3e50c258-8732-088c-d9d8-dfaae82213f0@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 17 Nov 2022 07:19:17 -0700
Message-ID: <CAMkAt6ppvVUHRCyOjba=_HmYPp_cZaQB1J=HLvFf8yRD1dXPPQ@mail.gmail.com>
Subject: Re: [PATCH V5] virt: sev: Prevent IV reuse in SNP guest driver
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@suse.de>, Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Wed, Nov 16, 2022 at 12:02 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 11/16/22 11:55, Peter Gonda wrote:
> > The AMD Secure Processor (ASP) and an SNP guest use a series of
> > AES-GCM keys called VMPCKs to communicate securely with each other.
> > The IV to this scheme is a sequence number that both the ASP and the
> > guest track. Currently this sequence number in a guest request must
> > exactly match the sequence number tracked by the ASP. This means that
> > if the guest sees an error from the host during a request it can only
> > retry that exact request or disable the VMPCK to prevent an IV reuse.
> > AES-GCM cannot tolerate IV reuse see: "Authentication Failures in NIST
> > version of GCM" - Antoine Joux et al.
> >
> > In order to address this make handle_guest_request() delete the VMPCK
> > on any non successful return. To allow userspace querying the cert_data
> > length make handle_guest_request() safe the number of pages required by
>
> s/safe/save/
>
> > the host, then handle_guest_request() retry the request without
>
> ... then have handle_guest_request() ...
>
> > requesting the extended data, then return the number of pages required
> > back to userspace.
> >
> > Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reported-by: Peter Gonda <pgonda@google.com>
>
> Just some nits on the commit message and comments below, otherwise
>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks Tom. I'll update with all the feedback after Boris chimes in.
