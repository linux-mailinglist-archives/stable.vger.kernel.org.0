Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFA5C60E
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGAXwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:52:04 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:38949 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfGAXwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 19:52:04 -0400
Received: by mail-pg1-f181.google.com with SMTP id 196so6742186pgc.6
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 16:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U3UCHfQa0yO6+9MSJSdhp8ydnzBOoWVKB7F2MUDXIbg=;
        b=b5Iea5vhGThzBv+VWqfZbdQPWSQb/trP2oBbiSl1ZLRctqr33FGui2k/L5AGnmsaV7
         22BsGyqjddZ3Wi5jEi48VQUnbZznpyn2+DkAdVy3r8kSlaGNo04U+/udCAyV3AjEqF5v
         Bkjrem0QYozuKu9xpdQRdVpt7Z1Va3i7P4HXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=U3UCHfQa0yO6+9MSJSdhp8ydnzBOoWVKB7F2MUDXIbg=;
        b=My2obofjiXShNAwtlZmolqjiLhV94McaSVS9s08bkogUGerTcCZ0MQsRjyvQh9K6k/
         OsVkYd/epY8GarLONn31lBFSc4VDO8dN60vPL8gpmfJRXcvzCRD1HuvoLjTDavH7fVhx
         tydaj1CxPsBkbFtxDJnas/lRB8b1w0BVSgZwu5pygwGnrBlsjvUu7nsm0RbCFX9MLMZm
         Ar1WVmOVrdLxmLL9K/helyjNRj/klcWlGO+P5DnN1GznPZtgMiWnWYd4yNEEr6D6YkkV
         omE/BeK0nddIB4FzoPxk6/D6ddW/fbkbwr0R3ZNHy1cftSx0fCoNt36gFP+aYaBIPhIS
         fMoQ==
X-Gm-Message-State: APjAAAXrrjdP6Hz8iVULn4BGEmQChQD9Gaf/0OEA3Z3cSWDF5MH1UBQT
        BixAS2yFVzTd7ihyykQE7xgs
X-Google-Smtp-Source: APXvYqz0b5AzL/SN3RQHm/dlupgSF+1Fo4cZiZxEFKyd+V0xZqiqECBH1Pl8dWl5yxYv7lc45QuLDA==
X-Received: by 2002:a63:4f65:: with SMTP id p37mr27044600pgl.327.1562025123383;
        Mon, 01 Jul 2019 16:52:03 -0700 (PDT)
Received: from [192.168.1.144] (64-46-6-129.dyn.novuscom.net. [64.46.6.129])
        by smtp.gmail.com with ESMTPSA id y12sm11153359pgi.10.2019.07.01.16.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:52:02 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: net: check before dereferencing netdev_ops during busy poll
From:   Josh Elsasser <jelsasser@appneta.com>
In-Reply-To: <CAGnkfhx3ykbEsW+=FtpMFWU=_Vnie7RpPYWpWqa1S1HPMXj9kw@mail.gmail.com>
Date:   Mon, 1 Jul 2019 16:52:01 -0700
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Transfer-Encoding: 7bit
Message-Id: <AFBE995B-8C7D-430D-B722-615C6CBBF6E9@appneta.com>
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm>
 <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
 <20190629074553.GA28708@kroah.com>
 <CAGnkfhzmGbeQe7L55nEv575XyubWqCLz=7NQPpH+TajDkkDiXg@mail.gmail.com>
 <20190701175241.GB9081@kroah.com>
 <CAGnkfhx3ykbEsW+=FtpMFWU=_Vnie7RpPYWpWqa1S1HPMXj9kw@mail.gmail.com>
To:     Matteo Croce <mcroce@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Jul 1, 2019, at 11:03 AM, Matteo Croce <mcroce@redhat.com> wrote:

> Josh, as you are the original author, can you please resend it to -stable?
> Feel free to add this tag:
> 
> Tested-by: Matteo Croce <mcroce@redhat.com>

For sure. Resent with your Tested-by, along with a second patch that applies 
to the 4.4.y LTS kernel.

I'm still a little hazy on how net fixes work for older LTS releases, so I
hope I've sent these properly. I can respin if necessary.
