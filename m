Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C92AE10904F
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfKYOqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:46:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37726 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfKYOqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 09:46:19 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so18363057wrv.4
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 06:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=U5rFbTDcUhKl4fxX+We/Q4K0+RTd7xucIFp4oCEQI/Y=;
        b=IYptBD8CBNHuFJ7SoVv9CwrAPtZuFhNAtzz5KQIAwHfmFDW7Yy2bnMyrfeqgjUcJRr
         8qpqbqVMUO63Kay5H2APfjpjN9kGOwB6t9N+S5jum7PNKnTHUzhKYxmKItb/bp8xrr/6
         QfBcVyRpcn3lXJTnL2LWZ38hvEyF9vd7L9x9P5X9qnoBbg7pH4/BODrsBQ9YMmwhzeeJ
         HxrL/bIyanAmEbGA3N2NwgxRK1tM7Q+TW0C+nsYwWVBnzRv2XbhBU0pO3etz/R3TOFGN
         SbcFeYM7fkcQkH1BvawjLijuGzRCV78w5Tewg2qc0PDTqZ3F9dCDeAL94i1ts40tzf6P
         qTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=U5rFbTDcUhKl4fxX+We/Q4K0+RTd7xucIFp4oCEQI/Y=;
        b=IDg0g6/Vpu7yBPgzjk6Q5/MNcnpdzFUkXmwqF19R5jncctEVrPbjEAjaOKq3w1iYeY
         QWYpt+FTF/7QLu7UQUXMvxQToHfA/y2qvHzlZTS2iqNlEC4A+WfwFDhBqKQJOSDXPu/t
         1Pt6jWiJEi30PDV+P8UvoYEREMzA2DHfPjm35BHyi6irAXmVSxa+U+vUcfx7GZjrojED
         VXo4a6O03Ee+C6FG1RJfqJ/dA0cdU9E5vZBPobfkikmyKOY/0TbP7XsbcRg7HFfZ7PR+
         kPZmNc/Xr+8FLnUsN7zBy70wvtt0f6r8pUFUMiuOYJHlJc8EjFYQ4onbEL544W1ZO7Rd
         A2FQ==
X-Gm-Message-State: APjAAAXNZycYW2ovZHBaoiLzFNPESMwurY4ZXbzAzkHDAx/2K2bxSspk
        UrJ15s71Yl0ix4dNEKtUMbWY7EadBec=
X-Google-Smtp-Source: APXvYqyIAIZv9bMOPfDoLPJwBHwpD/mDr3p1LO5Ti4P35zgnvXRZ1o/SjgGs3OHUysgaVyZ0yP2b6A==
X-Received: by 2002:adf:f651:: with SMTP id x17mr33496967wrp.114.1574693177559;
        Mon, 25 Nov 2019 06:46:17 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id i127sm8981807wma.35.2019.11.25.06.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:46:17 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:46:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 8/8] ext4: avoid unnecessary stalls in
 ext4_evict_inode()
Message-ID: <20191125144603.GG3296@dell>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-8-lee.jones@linaro.org>
 <20191125134835.GC5861@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125134835.GC5861@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Nov 2019, Sasha Levin wrote:

> On Fri, Nov 22, 2019 at 10:52:53AM +0000, Lee Jones wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > [ Upstream commit 3abb1a0fc2871f2db52199e1748a1d48a54a3427 ]
> > 
> > These days inode reclaim calls evict_inode() only when it has no pages
> > in the mapping.  In that case it is not necessary to wait for transaction
> > commit in ext4_evict_inode() as there can be no pages waiting to be
> > committed.  So avoid unnecessary transaction waiting in that case.
> > 
> > We still have to keep the check for the case where ext4_evict_inode()
> > gets called from other paths (e.g. umount) where inode still can have
> > some page cache pages.
> 
> This reads to me like an optimization?

That's okay. Just don't apply anything that isn't suitable.

I'll try to omit such cases in the future.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
