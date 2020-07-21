Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA0C22755A
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 04:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgGUCD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 22:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGUCD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 22:03:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E4AC061794;
        Mon, 20 Jul 2020 19:03:26 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f16so876655pjt.0;
        Mon, 20 Jul 2020 19:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5zlqxk9gLp6ihdSA1axrBIi1VVR4iiTsXABAYWkWZw0=;
        b=JjqloN85m13o6bcrMquLDGfRm4q6D/KdMQmr6Oy2AVNJTiNWB0bVDV60jZSO3Qbg5m
         SG22LWBx+aOcEQSt4/++mdhCkiXAs4rgR6Qew6oGTQu98n8nPCDLjhYSWw3rnzPNeD37
         dCwAnVpDV/EiDBQcS+AxmwIcRR31jHj1Topy8TbBia1vIKIfsG2fX74Fr37mP67mROI8
         vZdAq/KH2toR/jVrhlAqtGzA2b4yaKRdqfWItDyPIv94ItSHAgRIMXS2dxueaIld99qq
         bKNOa6V1edswy2ttLqXTxozC/3OcfoQ+6+EHJkyJSZkxEqP+yKqZfjdNPZOmfi53s3uA
         Z/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5zlqxk9gLp6ihdSA1axrBIi1VVR4iiTsXABAYWkWZw0=;
        b=Th8yMqUJaHJ8A9fMa8FaTbDtUDuE0JA0G8uJ39FZGxUduQzePScNCbg/k0p2xBRIIr
         p3UjGyPyArd+nP0sWyM9U9Sy0KJcrTmrvyDyPglEDyZxhcZzDvLWZwRJARNue48MsriM
         vwPwUQB3mHgxYXYEqgwfdnr2RLDkxWmjnUQPV1Dag0lRH7Daw35uDDAm1GvLJsW/+rVi
         /PU5mrohHrmd8/fILrkxLI2e8DFSGmh5RwxLqghaZJ2xs8vJFXfvFAdcc5ictq14j+S5
         tneww3r04wc0t9YguLo7tfgoK8U0S5OlDGM8Qf6HrjcV6JXQyqi8VtCIXOxPW0VneL1B
         7QPA==
X-Gm-Message-State: AOAM530NfZbz2qald19HRUIOyFnkz0L7sMPzdyKsSWD3tlRoGQbJy1Xd
        rMMEwPdtfQutpkFvlEAFLSM=
X-Google-Smtp-Source: ABdhPJx9lso+A8gYOduhg+msXjHtKgUUqoS+LbbMecZsJfkCyJzdXNMZ6HZug06xHUnjnW06RhF9Hg==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr2239412pjw.35.1595297005907;
        Mon, 20 Jul 2020 19:03:25 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id g19sm18108556pfb.152.2020.07.20.19.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:03:24 -0700 (PDT)
Date:   Tue, 21 Jul 2020 11:03:22 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jann Horn <jannh@google.com>, Petr Mladek <pmladek@suse.com>,
        Theodore Tso <tytso@mit.edu>,
        John Ogness <john.ogness@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 130/133] printk: queue wake_up_klogd irq_work only
 if per-CPU areas are ready
Message-ID: <20200721020322.GA715296@jagdpanzerIV.localdomain>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152810.011879475@linuxfoundation.org>
 <20200720220506.GB11552@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720220506.GB11552@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/07/21 00:05), Pavel Machek wrote:
> > From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > commit ab6f762f0f53162d41497708b33c9a3236d3609e upstream.
> > 
[..]
> 
> Is this still needed in 4.19? 1b710b1b10ef was reverted in 4.19, so
> there should not be any user-visible problems...

printk_deferred() is still broken and we had similar bug reports which
where not caused by 1b710b1b10ef

	-ss
