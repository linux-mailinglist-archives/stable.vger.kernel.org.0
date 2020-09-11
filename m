Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A26265F51
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 14:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgIKMNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 08:13:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgIKMNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 08:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599826352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpSJZoDhXU8Bl8cIqyk1fDl2xLvOrmyAbOIbzanIsbk=;
        b=CyAWg8On73k4z81bGzC2y7+ER6dbGGnw2bl6NElXV5vTgC3hQ/tG8djyw+x1t1zMlMXLcm
        h6/DbHeWM0yJ6dYKF14jHgqau1os4ZmxotZ8jXaEghEvSfyO8tN7Yar+92gU2C8w3Ok4oQ
        1xyCiwskBRIx2IzByqYqvLyzWfy24Gs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-3bEbY60DPFKdy94RtXqX2w-1; Fri, 11 Sep 2020 08:12:30 -0400
X-MC-Unique: 3bEbY60DPFKdy94RtXqX2w-1
Received: by mail-wr1-f71.google.com with SMTP id r15so3422173wrt.8
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 05:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WpSJZoDhXU8Bl8cIqyk1fDl2xLvOrmyAbOIbzanIsbk=;
        b=mV1qpNvJ+0fnAD4FWmmBIGmqEKRyLkV7n+Cm/dTfqMotX44M9arWOp+D1FtxOgxxT7
         XiBw0SFjN08Ttjii77m+UAhRcr8npWFAn9fJ/v+nEuJM19uvN+2c5wG4e+PFdm4xKR4E
         qG/TUXW2pd9xiEuuAJ2NCnz3Kjd3+K+jpMgJVXASIajLYunbYGwQ+XVYyVWpoPeY6J1y
         F/2R4gV6bJKU7Liuo+eFVVZGfd8HDGvV5MaBSMlgmlSSLqPObo5AnxYF9uZ+QuqzxoMq
         ehue2nhL9cc5vIzftmeDdcxgkYx8NkJXj9sTB8f9tm+zYpFBISZMQ7Y7tFV1hV7XKFfA
         sIQA==
X-Gm-Message-State: AOAM5333KBtRrT4AytQe8QgTcy1823PiJbhvtegD0b5biEPHFtg7vTXz
        ZjJYpUmLnwk3NNzr9CKvfXOnBNosjxW0N/DGWFRHLwKhhdvYeWDn8WpmN1k4KVcA4EzMuAQG6kR
        vYqOjalESCYl5IvcdEPEf4qrQFkawQDUJ
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr1782470wru.329.1599826349297;
        Fri, 11 Sep 2020 05:12:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2UcPBLQ0l7SPS9t0/toMzg9RpVOraIQlfIv6RFuu9TW58mkfeZOObj5sfwveO+dt5rkefD7fFw5kHsJV91Z4=
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr1782450wru.329.1599826349139;
 Fri, 11 Sep 2020 05:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200623195316.864547658@linuxfoundation.org> <20200623195323.968867013@linuxfoundation.org>
 <20200910194319.GA131386@eldamar.local> <20200911115816.GB3717176@kroah.com> <20200911120854.GA221663@eldamar.local>
In-Reply-To: <20200911120854.GA221663@eldamar.local>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 11 Sep 2020 14:12:17 +0200
Message-ID: <CAHc6FU5iH5LdCQA5qGKbu0gqO1p+-A2Dn8XYahXCLJNB4JSqWA@mail.gmail.com>
Subject: Re: [PATCH 4.19 142/206] gfs2: fix use-after-free on transaction ail lists
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Daniel.Craig@csiro.au,
        Nicolas Courtel <courtel@cena.fr>,
        cluster-devel <cluster-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 2:09 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> On Fri, Sep 11, 2020 at 01:58:16PM +0200, Greg Kroah-Hartman wrote:
> > Can you report this to the gfs2 developers?
>
> Sure! Bob Peterson and Andreas Gruenbacher were already on the
> recipient list but I forgot cluster-devel@redhat.com .
>
> I can send there a separate report as followup if still needed.

No need right now, we're looking, thanks.

Andreas

