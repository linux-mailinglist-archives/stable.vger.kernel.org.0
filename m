Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB5A4C0BB
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 20:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSSXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 14:23:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38502 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfFSSXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 14:23:09 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so45391ioa.5
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 11:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bCg0PxUUsvAJMl0OsP+eCKdKGJyA+gTCYYarz6iUG8Q=;
        b=cQqMniCU5VY2ftDUi25CRJrJX15bCr9pWzFmAOsvCab/aBwZjL+1bsoBE06ZtUhppe
         enHmXOLVSQ+ZesBpy/zmpdoBYl15w4+eDVIuoaaDpq5mhnj77ziMZmMQkI2Qz0YJkfwe
         NH//I39YaHmhRk2Ch76r7fUfWkI1VFktBshFXcgyNfWCQPbMDKbObAdLfbAVRuQpd+R7
         K93urgFlSmDs+oeIImId6iMTpya8+LFQ2QfmvTOSQRwT3sTrzA+rDPb+iBSesEHF1XlS
         9zOd1Z/DLek13dtS6k6JBXyqnqjaSQOoBhHWVpHuo+QnPAjMYozqqSfYdfaCKpKHs4ZK
         T+Ag==
X-Gm-Message-State: APjAAAVcC+BTBVpbKUKL75Ves52+BXWpsAA4QbMiM2N/nBLNSvC7gZTU
        6mgCmWl2+GtJ56yyYjXeIjbh0Q==
X-Google-Smtp-Source: APXvYqxHxmypQJeYzLb7QJDeP7k96N72SWAafQUJZuT5yiamhtx9tn2JFFjVgcIpCM8ez+a8G0nipg==
X-Received: by 2002:a02:b016:: with SMTP id p22mr49908290jah.121.1560968588808;
        Wed, 19 Jun 2019 11:23:08 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id r5sm19165770iom.42.2019.06.19.11.23.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 11:23:08 -0700 (PDT)
Date:   Wed, 19 Jun 2019 12:23:04 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak
 when shutting down request queue.
Message-ID: <20190619182304.GA98587@google.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
 <20190514091933.GA27269@kroah.com>
 <20190619164625.GA85539@google.com>
 <20190619170917.GC10107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619170917.GC10107@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 07:09:17PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 19, 2019 at 10:46:25AM -0600, Raul Rangel wrote:
> > On Tue, May 14, 2019 at 11:19:34AM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
> > > > I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
> > > > https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
> > > > potential resource leak when shutting down the request queue.
> > > 
> > > Potential meaning "it does happen", or "it can happen if we do this", or
> > > just "maybe it might happen, we really do not know?"
> > It does happen if the AMD SDHCI patches are cherry-picked into 4.14.
> > https://lkml.org/lkml/2019/5/1/398
> 
> Why are those patches somehow being required to be added to 4.14.y?  If
> they are not added, is all fine?
I was just thinking we would backport the patches to fix this AMD SDHCI
hardware bug, but I guess we don't need to.

Thanks
