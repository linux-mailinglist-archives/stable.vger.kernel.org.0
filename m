Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327584E8658
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiC0HBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 03:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiC0HBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 03:01:46 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD7B50B35;
        Sun, 27 Mar 2022 00:00:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o8so9819201pgf.9;
        Sun, 27 Mar 2022 00:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B0zrfPEDf4e6Muxcxkz/ovZxAtJjbnxgK8f96p1+0Ck=;
        b=jGj7DxIxbQDEybCOraMIwxMI2fjdiKS80eNF0u8LceCAdpoMvK9TpKZFHj66yn/PvU
         Y7dusyT/9mhdjtHJvQuczJa99J5CDjLO9ar+k0c6DeeN1AN9j029JnROqmo2vOGpByqa
         nxetEzGOppd1xJWdDsm2w8SMIQc6eZ8IStMegiMf9eAJGRzSQ/w0UITMvPnEns5X5bnI
         ahhYx79wbgHwl1uymG2X8tRrGrODU4gR8ye3rWk8Wz92cj3TgtDK0A0B4B73+JsG6nCd
         fPNcjjI8mnMktphoDaszyRT3RvfEZgyLWO2WItjFtWrK9Xw4rkziT5GOOd6noYJw2BzK
         /bxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B0zrfPEDf4e6Muxcxkz/ovZxAtJjbnxgK8f96p1+0Ck=;
        b=b0TOiyImxfPhWu/MwavVBnk57FtMUeIaKhp/zfGNqCU4N+lhzspsB0ZqoFXWLkfcLk
         iLQDKG+RYiKzMKnlvRzcDY9izBeK1dFGOav1V/ou1eVlOjYf2jIBQ1t9I/8d5yBaWSFL
         W68En4qmJXvi0uba6iV6Fi89eUdgAsyr2E4YWzxTS6VjPXQgTiyKE4YLEU7+iRT/O0wf
         LQKc8xwBag33wV8WkMTNWrKvVB0OJv3PKe9IsxMS+rYTFlsauclJICFlD4G1IJ6Yaglg
         mJw08qAnsHSMSIAnVArb9G7lfCe3Nn9fCfb96HmiS1VB1A8VbJChccKQNEIVcORaPsQr
         JA7g==
X-Gm-Message-State: AOAM531z2jdVpBPQcDhqHy5Kqic+h7VoXtYqURxiKX8gHhQ/fEuGDo8l
        ywZ7zKx4WKvp1WedsBzUkFc=
X-Google-Smtp-Source: ABdhPJywbizoZk4XOW6LYGf7wmYWM2ocTqSR5GKSGYZ8m/s7E/ivTY1Lj3nXe2pu5WnBz7Ftb5RN/A==
X-Received: by 2002:a63:6949:0:b0:380:94ab:9333 with SMTP id e70-20020a636949000000b0038094ab9333mr5839368pgc.199.1648364407607;
        Sun, 27 Mar 2022 00:00:07 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a2b8a00b001c6594e5ddcsm10698140pjd.15.2022.03.27.00.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:00:06 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     linux@roeck-us.net
Cc:     airlied@linux.ie, bskeggs@redhat.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, kherbst@redhat.com,
        linux-kernel@vger.kernel.org, lyude@redhat.com,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] device: fix missing check on list iterator
Date:   Sun, 27 Mar 2022 14:59:50 +0800
Message-Id: <20220327065950.7886-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <80429172-37c6-c9ce-4df7-259bb90338a8@roeck-us.net>
References: <80429172-37c6-c9ce-4df7-259bb90338a8@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 26 Mar 2022 22:38:05 -0700, Guenter Roeck <linux@roeck-us.net> wrote:
> > @@ -103,11 +103,16 @@ nvkm_control_mthd_pstate_attr(struct nvkm_control *ctrl, void *data, u32 size)
> >   		return -EINVAL;
> >   
> >   	if (args->v0.state != NVIF_CONTROL_PSTATE_ATTR_V0_STATE_CURRENT) {
> > -		list_for_each_entry(pstate, &clk->states, head) {
> > -			if (i++ == args->v0.state)
> > +		list_for_each_entry(iter, &clk->states, head) {
> > +			if (i++ == args->v0.state) {
> > +				pstate = iter;
> 
> Is iter and the assignment really necessary ? Unless I am missing something,
> list_for_each_entry() always assigns pos (pstate/iter), even if the list is
> empty. If nothing is found, pstate would be NULL at the end, so

the pstate will not be NULL at the end! so the assignment is necessary!
#define list_for_each_entry(pos, head, member)                          \
    for (pos = __container_of((head)->next, pos, member);               \
         &pos->member != (head);                                        \
         pos = __container_of(pos->member.next, pos, member))

--
Xiaomeng Tong
