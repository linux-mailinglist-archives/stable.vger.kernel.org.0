Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE619002
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfEISLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:11:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40437 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfEISLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 14:11:09 -0400
Received: by mail-io1-f66.google.com with SMTP id s20so2352375ioj.7
        for <stable@vger.kernel.org>; Thu, 09 May 2019 11:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4B4cz9TQlVrtNHSS4lZqMKxEYeza+mUeJV50La5IFHw=;
        b=e2nl1Q1JAyI6bP3sBpvDyfF6MgqfZt3MW1m1VhzL0+Zivh1+2iF6n5xH3qkDT5Ln7M
         YlxCM0M+027qGXNNBVicbwu6nTfp1IJvgecrYQPBQtvlEaIEvnq8fwT400Ppe/XhK151
         FbLeKNo4qvEF0v8qrQeYJ2RbFAxaZy9ULfchdq9GIF/ecX/QJA+x/vpu/THT0pl/SE54
         qS0iLhAkD+JXuBI2nYPSTwhR+4HKMtgCZr+hg0sO5MVnRRNvr0cf8KeQYJVYBiNRZ/g5
         dqyn4USUT6CVuhA7j0muFqC7lRY/Gqs6gb7IqNne/Tvhet0Oraw+b/BOLTRvVqIq+y+9
         3CBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4B4cz9TQlVrtNHSS4lZqMKxEYeza+mUeJV50La5IFHw=;
        b=OdBmgxe9NSe+zX8aTaSs5uy6FJcG+P5h+sey1q8vyXWqOT1PdVAoH+5hmWScxFHQgJ
         6Dj3qW7y+xVutvXqDkyt44OfZD5rkk4n0vRVkXWtMwnJCsZaCywD7MZQNufVrHobacrP
         KU27p8KunavQ8gtwFcPxV5FrGLsEmtKpBW+h0ZAR7iNUngKTS8+MEHxPSLxtp+33QiLI
         YtL0us6bsU2Kkz1Xe49Q+FfnJwu6x/4+N0ANx32eZE5jdosWXkDTP8vnyYm+R5mekaAS
         V0YBde9+2VhApZcDdRt2+0bXBRNqKM5UXOO3ZeESX0vWtjwCPyVs5u0nwCHVrePZX+lN
         t1Tg==
X-Gm-Message-State: APjAAAV8hFPBVhuGVPXUG5P3p+zKCgdg2H2sml/GiD/Md+rsbytlBBKf
        Az19oBk83UNWusWInOBDl65TqQ==
X-Google-Smtp-Source: APXvYqw7BOoZw/9P08bflD1BVPG1bwN1p3Cb7uvUExZieb7iSdlea7oMCKe39dfrig+MVyPrAnJBfg==
X-Received: by 2002:a5d:8d81:: with SMTP id b1mr2792754ioj.83.1557425468400;
        Thu, 09 May 2019 11:11:08 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id f129sm1281458itf.4.2019.05.09.11.11.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 09 May 2019 11:11:07 -0700 (PDT)
Date:   Thu, 9 May 2019 12:11:05 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ross Zwisler <zwisler@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [linux-4.4.y PATCH] ASoC: Intel: avoid Oops if DMA setup fails
Message-ID: <20190509181105.GA43688@google.com>
References: <20190429182710.GA209252@google.com>
 <20190503194503.77923-1-zwisler@google.com>
 <20190505131553.GB25640@kroah.com>
 <20190509174147.GA17342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509174147.GA17342@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 07:41:47PM +0200, Greg KH wrote:
> On Sun, May 05, 2019 at 03:15:53PM +0200, Greg KH wrote:
> > On Fri, May 03, 2019 at 01:45:03PM -0600, Ross Zwisler wrote:
> > > From: Ross Zwisler <zwisler@chromium.org>
> > > 
> > > commit 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 upstream.
> > 
> > This commit id is not in Linus's tree :(
> > 
> 
> Sorry for the noise, I didn't read your note :(

No worries, sorry for sending early.  I'll wait until after it's merged next
time. :)  Thanks for pulling it in.
