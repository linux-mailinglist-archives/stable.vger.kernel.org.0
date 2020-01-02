Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD53B12F18D
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgABWLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:36 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44108 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgABWLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 17:11:33 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so35166536iln.11
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 14:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TAtfJttIxgArAqalRsE9mMvgtVv8FMRCh1uwyT0m3+U=;
        b=b5cb8HgUn4y016LDct8uf0JTFFVeYaYwRcAhgHCEDnLIHkkpkU4qCQ7GfhDlpj0FXU
         vrxRYrkRj2vWcu+d7IV3n1qOjZRJwnXU5v5HZAaqEZV0UitQ5JMHn0C0KLwIY7aAX+ck
         U6MPxHWIvCxXYVoK1UlSZzG7YiqNKxGXKvfS6wSo1B1HIIwS8+33Ww8T2KoSfouFnbfF
         LmdojdZJwHivimho2ptOWiBMwVmyqGRYGwogVDEiLG+EOqjf2bcdScFU9bpb5XNgfmXS
         H6yY30fkWBJrZu/TSYuAUiSPLdCPrinRp3ixiPuxjIiysePaLtW9esTb4Unyf+wV8wSn
         lOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TAtfJttIxgArAqalRsE9mMvgtVv8FMRCh1uwyT0m3+U=;
        b=I8tKBSoQ5B3TuESoE3zuacOSq+w4swcSTe4bfm8fHrYV/0npndiPuCQ3LP+thD2p4A
         UjVn0+0M07HNdJP9lSkQyIPCulZXZWWeuy2H5pknBRdhovsruSvec3w2AmxRUeOXeXpP
         UXtSNC9f4AX2I8K1ORS4v0YsFyG/d27QZbqhtyDlgaKxQv6Yl5BUhKvUhSvdXv/Ax1DL
         lWJE5IpIFlFRL5ZxEDdop2Xpy+xPrbfZuuELeBjRKsERp7auIiWwV0qw0oZev8OOd1wa
         DHNLgBz/7QytfeMHHJ3jT8WlMNasAwnt1YaA/Art42LOqZHaNklULdsvO1MIs+LooRo3
         1QZg==
X-Gm-Message-State: APjAAAVh+pB+XRCFIp35eZeU/oIxiOH/bOXUX6VueDuMw6XP+wqalFtL
        L3GlaAtTEoqFFy5Sz9JErvNAmPcFX1CRQ951eaQKJg==
X-Google-Smtp-Source: APXvYqzYO9o7e9dax4o03rQ8+nEvALSLVpe9d466//omxSnHfUn6rcS4fod16+2cw5Ij/dhQ4kUi74aztq45/Jhb3yI=
X-Received: by 2002:a92:d642:: with SMTP id x2mr71916941ilp.169.1578003092636;
 Thu, 02 Jan 2020 14:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20191213225748.11256-1-matthewgarrett@google.com> <3a472005-83a7-9787-0bfc-35673702be09@molgen.mpg.de>
In-Reply-To: <3a472005-83a7-9787-0bfc-35673702be09@molgen.mpg.de>
From:   Matthew Garrett <mjg59@google.com>
Date:   Thu, 2 Jan 2020 14:11:21 -0800
Message-ID: <CACdnJusAW=R0XgaZwfY2G_5cJzoq94RYiyzj09jLEbZqWRbjzg@mail.gmail.com>
Subject: Re: [PATCH] tpm: Don't make log failures fatal
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 4:15 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> Am 13.12.19 um 23:57 schrieb Matthew Garrett:
> > If a TPM is in disabled state, it's reasonable for it to have an empty
> > log. Bailing out of probe in this case means that the PPI interface
> > isn't available, so there's no way to then enable the TPM from the OS.
> > In general it seems reasonable to ignore log errors - they shouldn't
> > itnerfere with any other TPM functionality.
>
> interfere
>
> Can this be tested with QEMU somehow?

I think you could hack ovmf to disable the event log, but I can't
think of a trivial test otherwise.
