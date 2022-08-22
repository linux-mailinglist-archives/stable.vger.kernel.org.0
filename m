Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994B959BB90
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiHVI2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiHVI2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:28:25 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816E6B7C9;
        Mon, 22 Aug 2022 01:28:18 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9882329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9882:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8CAA1EC04DA;
        Mon, 22 Aug 2022 10:28:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661156893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3t9+6nfiuQKFvxF6QSwH6wfi0OEdPc0eB0BQ88sluiw=;
        b=LBTgUcDzl5EdkYRDDlSD9fBZ0rURljXWITRA9M9N8bU0uOJgF0ELIcgHu1BNxGDLbs8SjS
        rzXJHZvhI0nkzVUuapeB4U5odChwEb15KS+ReeR2th/1wYx7PdbXEUpL1kh3/p9CNFT3dm
        aQbFCNV0IyjQbUqZostPTwFiS+hKwUg=
Date:   Mon, 22 Aug 2022 10:28:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
Message-ID: <YwM+GPu8hFowl2R7@zn.tnic>
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com>
 <YwIkV7mYAC4Ebbwb@zn.tnic>
 <YwKmcFuKlq3/MzVi@zn.tnic>
 <f205da1c-db33-299c-5fc6-922a8ebd1983@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f205da1c-db33-299c-5fc6-922a8ebd1983@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 07:17:40AM +0200, Juergen Gross wrote:
> And then there is mtrr_state_warn() in arch/x86/kernel/cpu/mtrr/generic.c
> which has a comment saying:
> 
> /* Some BIOS's are messed up and don't set all MTRRs the same! */

That thing also says:

        pr_info("mtrr: probably your BIOS does not setup all CPUs.\n");
        pr_info("mtrr: corrected configuration.\n");

because it'll go and force on all CPUs the MTRR state it read from the
BSP in mtrr_bp_init->get_mtrr_state.

> Yes, the chances are slim to hit such a box,

Well, my workstation says:

$ dmesg | grep -i mtrr
[    0.391514] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.395199] mtrr: probably your BIOS does not setup all CPUs.
[    0.399199] mtrr: corrected configuration.

but that's the variable MTRRs.

> but your reasoning suggests I should remove the related code?

My reasoning says you should not do anything at all here - works as
advertized. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
