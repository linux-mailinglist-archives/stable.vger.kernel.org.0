Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1830E6BAF6A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 12:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCOLjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 07:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCOLjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 07:39:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719CE977D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E113661CE7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B87C433EF;
        Wed, 15 Mar 2023 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678880338;
        bh=XmAs7En2IOf9PJhbryki/5GljL4UrSmc0/jgkl9RQCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2eoU4UUlCI/Bi9Ro8J428wTfdodelMhLAeulOZ8ckNeV7JNUEHvji58EqiyftODQk
         v2LNE4mFuaw6akCfk2uSsiNKkmXe//QmkIa6TBbWzhoks3WgzaJIe5jF92sn87kvdF
         033fFGLILjXhznx3owlMSCf36fPigrXji4Xix4h0=
Date:   Wed, 15 Mar 2023 12:38:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de,
        pawan.kumar.gupta@linux.intel.com, cascardo@canonical.com,
        surajjs@amazon.com, daniel.sneddon@linux.intel.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 v2] x86/cpu: Fix LFENCE serialization check in
 init_amd()
Message-ID: <ZBGuTyjM9/IAqJi9@kroah.com>
References: <20230315104015.3607718-1-rhythm.m.mahajan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315104015.3607718-1-rhythm.m.mahajan@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 03:40:15AM -0700, Rhythm Mahajan wrote:
> The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
> which was backported from the upstream commit: 2632daebafd0 renamed the
> MSR_F10H_DECFG_LFENCE_SERIALIZE macro to MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> The fix for 4.14 and 4.9 changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function, but
> should have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
> This causes a discrepency in the LFENCE serialization check in the
> init_amd() function.
> 
> This causes a ~16% sysbench memory regression, when running:
>     sysbench --test=memory run
> 
> Fixes: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
> Signed-off-by: Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
> ---
> v1->v2
> Corrected the formatting of the commit message.

Now queued up, thanks.

greg k-h
