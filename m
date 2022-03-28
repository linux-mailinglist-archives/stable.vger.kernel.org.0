Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B74E9EB7
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245093AbiC1SKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbiC1SKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:10:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFA205D9
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:08:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so121280pjf.1
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hNzwHJfpkpmEw/hct0zF3etMNc0cBO4fopLuf3JQwh0=;
        b=j+MhoQtHPKvT8/iY4rD3ORM6UPsD3J+KwsMPPTxs+VaA/Ye0qfO43/9gyfVuw4bCCA
         KbU/ghqbikyVT+ikaf+dcsZF2TeNWINi5mbTZggLvUyb115NvU/oAG33I26VRaF8bKGv
         fqoivDS1ir2euXvQJAeIFbIc+fobV0swxGnNdPUz6OSYyRXzS2+idViGDCpaqxbLKRmM
         7c3IFwx3BSmgGECIzf/upkN0mXZb1kOoPc0O49ZMigPY4P7UvIl1qUnd7wX7unjYa9e5
         t/FmYQi3oO4uToIrj4vwRJZ4OJuXX6VogEvlTaXHke65bPUHgcfJ8MdGKhqmmVN0uatg
         ZoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hNzwHJfpkpmEw/hct0zF3etMNc0cBO4fopLuf3JQwh0=;
        b=HF2rXd32lQQ62MPo9huE+Si/yZvnusjeyjxVZjISfnvYs49+xlypjr4HWm8yNI4mu3
         1aOWUWgZyAWt4zaEJ66zu9E0vWLHMUFNzZf3qG0Utnfk0Bg2df24gnYanRmprwatftRw
         6hFkSCO2S+JzPnKUX2DCJZDviAID4QqaTJH2upD9wQgcmEePzn2ngtfjUQAn6XQ/dCYe
         jUtVtvVFGUq47mSPzXNBUGGA5PcrhNk8H5ZAGuIBLJ5npSvkSoIqybwAvkUrIU0AnlqG
         Jd5x0TdrpvOnC1C4bX/7RbYgvA0NlNZth+OQX/wfyKPF3wKgHVU/H+yolWJLtsftBMsp
         zEog==
X-Gm-Message-State: AOAM532nNlFgE+y6R0gtAH5O1zQHqHO2zizQ7zCgi79tY/w9oIk1Ccws
        yRZui7Jc4j/2PzANE+Rtk7Orrw==
X-Google-Smtp-Source: ABdhPJxetOLScKRUcMTopUmhm1Ev7y4iwJyX08ybSbGXjAvTgYb2EcxGlWoFK/86lsZmPt0m0MtlmQ==
X-Received: by 2002:a17:902:be18:b0:153:2444:9c1a with SMTP id r24-20020a170902be1800b0015324449c1amr27513128pls.152.1648490909947;
        Mon, 28 Mar 2022 11:08:29 -0700 (PDT)
Received: from google.com (128.65.83.34.bc.googleusercontent.com. [34.83.65.128])
        by smtp.gmail.com with ESMTPSA id oc10-20020a17090b1c0a00b001c7510ed0c8sm145308pjb.49.2022.03.28.11.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:08:29 -0700 (PDT)
Date:   Mon, 28 Mar 2022 18:08:26 +0000
From:   Eric Biggers <ebiggers@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
Message-ID: <YkH5mhYokPB87FtE@google.com>
References: <20220328111828.1554086-1-sashal@kernel.org>
 <20220328111828.1554086-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328111828.1554086-16-sashal@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 07:18:00AM -0400, Sasha Levin wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> 
> [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
> 

I don't think it's a good idea to start backporting random commits to random.c
that weren't marked for stable.  There were a lot of changes in v5.18, and
sometimes they relate to each other in subtle ways, so the individual commits
aren't necessarily safe to pick.

IMO, you shouldn't backport any non-stable-Cc'ed commits to random.c unless
Jason explicitly reviews the exact sequence of commits that you're backporting.

- Eric
