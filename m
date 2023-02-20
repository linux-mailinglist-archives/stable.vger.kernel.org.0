Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5981969D27E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjBTSCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjBTSCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:02:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D61211E0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57C6EB80DB5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE17AC433B3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676916130;
        bh=FEnH8PA47nkF30lpCZ/PsYPNrdatuY2N3fVeRs38P1g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BAJCJNgXhTI+55FmsD6yI/js22y2zm4VA+liPSoXnRgRrw8EmUPj2vqR2bAQzPiXs
         t4Co0xbkFdI2/zD/Ivy5ZzwNrXFRWgmqsjnosEdu0bCfXJDWTnucJteItSzXl4KHDT
         HVmWtoaA0iNwteQCfjEFoN58a050oCjltqpmOk6lb7ESXMY+SPHYULtdTPHTsMrSvN
         cszam0E/675eEbDXO6i291xcTh0as/MXfjt0R03gRP88yXBjjNUT887ZMhBc9sSrF2
         PMEEacUjvg03pwlLqdtAdFjWqq1b48RGS6yPy0HOic3mW2NZT3XbQL5HUa4ofYF7VF
         wg8v0qPEJRLYQ==
Received: by mail-ed1-f46.google.com with SMTP id da10so9067212edb.3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:02:09 -0800 (PST)
X-Gm-Message-State: AO0yUKWa412FGcnrGHwYTu0C2umS5oskFyVDr+M4d0Gui5HvvIY3+6Et
        6Za357gn38QMDM8TYvl5nC9JGM0nQtTxIejlOea4bA==
X-Google-Smtp-Source: AK7set9rqzzR8nu8ZEnT5HrUX9cdHQJjqiaSVVtsIvKc/kOcHDxCLncbkWwVaTJfKM88w0q89eZkGI0Lh84yMPyf9Oc=
X-Received: by 2002:a50:c301:0:b0:49d:ec5e:1e9a with SMTP id
 a1-20020a50c301000000b0049dec5e1e9amr585704edb.7.1676916128128; Mon, 20 Feb
 2023 10:02:08 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic> <20230220175929.2laflfb2met6y3kc@treble>
In-Reply-To: <20230220175929.2laflfb2met6y3kc@treble>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 10:01:57 -0800
X-Gmail-Original-Message-ID: <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
Message-ID: <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 9:59 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 06:46:04PM +0100, Borislav Petkov wrote:
> > On Mon, Feb 20, 2023 at 08:34:42AM -0800, Josh Poimboeuf wrote:
> > > We will never enable IBRS in user space.  We tried that years ago and it
> > > was very slow.
> >
> > Then I don't know what this is trying to fix.
> >
> > We'd need a proper bug statement in the commit message what the problem
> > is. As folks have established, the hw vuln mess is a whole universe of
> > crazy. So without proper documenting, this spaghetti madness will be
> > completely unreadable.
>
> Agreed, and there seems to be a lot of confusion around this patch.  I
> think I understand the issue, let me write up a new patch which is
> hopefully clearer.

Feel free to write a patch, but I don't get the confusion.

Well, we disable IBRS userspace (this is KENREL_IBRS), because it is
slow. Now if a user space process wants to protect itself from cross
thread training, it should be able to do it, either by turning STIBP
always on or using a prctl to enable. With the current logic, it's
unable to do so. All of this is mentioned in the commit message.

>
> --
> Josh
