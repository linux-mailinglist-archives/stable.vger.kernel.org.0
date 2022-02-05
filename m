Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36334AA69F
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 05:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347023AbiBEEjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 23:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiBEEjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 23:39:10 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D5C061346
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 20:39:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cf2so1345123edb.9
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 20:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=VeyOjtqMATDB6OmjThAxXwLzxaA+1KnSmzmEVYO33MU=;
        b=CebpLAyIR71kbRNizSYvUF1/K6WfD2vgfJReEF8riuPqEVKuHkCSGGlTZi+nlFqyLE
         YiAu7zmHAl0pyabNzbZRPpBRSTr742g6daynVtkBn5+ujNpJi2n4X9bt8JA4lkRynBw7
         M8JDCXM9GRNOjntBD+dlKnXZ/bU6cXdRVETCbuADGsyB6Nn4k+qbU4d3ffqhLg3lFRxf
         mLENeEjJ+lW9wRkkza392/p27ZuppAXiBggSs0wYnqeS6MPN2ePIu9gcORxh7TlGsMLC
         QO9hNwUl3KZF370aFXwYOoGc3I/zVSR9b/C1muRUPZUxyB696MfXvd4a3n48dIUyjhyN
         uuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VeyOjtqMATDB6OmjThAxXwLzxaA+1KnSmzmEVYO33MU=;
        b=xZmolJVw3aHA3mP2lGy6egYGjSrEvmuCZfWbZN18a0T4LJpwZfZ2ourOzVqfbgh2pz
         x7JrGnOjsUT9NyLgd+nyL+ptJ2e179opB0LwMhsOjIcSCCTlOtzjAoVpnNoyNvkKoGyH
         9xNbGC56qqYqzFpuC9fmAjBKxka5sLyDKhW4SSF8tyiO3q38YlmSfnYCHoyt3kc2kYNd
         2eEs6uvNd/v5TZus8BF2ClEXwnOUfcntipf8a3GUZjnnQfd0kDNJwne8QvUgVQt8C3xi
         +32fUJVr2xgEsiYXbuZ5wFi1N/aG6yC7l/i1fbUVWlb7Hp54ngCUKSwuEpHtmmGGU5fT
         9lGg==
X-Gm-Message-State: AOAM530kTu5cz4WcbXJJgmex52AJxvOyCnZfiHNsC0k99663VWki0w1S
        Zbdct04olCi8UNEP2fROsqX8BVYpfm8SK8e0cWkH/CP8u1c=
X-Google-Smtp-Source: ABdhPJwWt1K45f5ROeCAn2nu3tq1Iv4TnzxDfLJGYAXxu12v+MHtrHO4CZfFnOd9/jbR/UPVbCDLhDTWnX5mwoYgHyg=
X-Received: by 2002:a05:6402:34d3:: with SMTP id w19mr2485095edc.377.1644035947350;
 Fri, 04 Feb 2022 20:39:07 -0800 (PST)
MIME-Version: 1.0
From:   Mario Kleiner <mario.kleiner.de@gmail.com>
Date:   Sat, 5 Feb 2022 05:38:56 +0100
Message-ID: <CAEsyxyjjsOugaA4VOpayCVNGCtHoZsyBpadLeDoVVUNDsBLW-Q@mail.gmail.com>
Subject: drm/i915: Disable DSB usage for now -- Backport to 5.15-stable
To:     stable <stable@vger.kernel.org>,
        Mario Kleiner <mario.kleiner.de@gmail.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit id in Linux 5.17-rc:
99510e1afb4863a225207146bd988064c5fd0629 ("drm/i915: Disable DSB usage
for now").

I'd like to nominate that patch for application to the 5.15-stable
tree. It applies trivially after dropping the  ...

.has_pxp = 1, \

... line of context. That line of context was introduced by the
unrelated feature introduced later by
6f8e203897144e59de00ed910982af3d7c3e4a7f ("drm/i915/pxp: enable PXP
for integrated Gen12"), so can be safely dropped.

Disabling use of the DSB for GAMMA_LUT updates should fix corrupted
display colors on Intel Tigerlake, Rocketlake, DG-1 and Alderlake-S
Generation 12 graphics. Good explanation is in the upstream commit,
but for reference here the bug report which led to the bug diagnosis
and fix:

https://gitlab.freedesktop.org/drm/intel/-/issues/3916

This would make high color precision and HDR display modes usable on
Gen 12 graphics with Linux 5.51-stable.

Thanks for consideration,
-mario
