Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159B41402DB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 05:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgAQEPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 23:15:10 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39332 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgAQEPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 23:15:10 -0500
Received: by mail-pj1-f66.google.com with SMTP id e11so2684719pjt.4;
        Thu, 16 Jan 2020 20:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bbL7DykLMjR4IBh+1blOFW3gZb5qagjDzhxfjiFEjd8=;
        b=qK6PT7KCcMfj1muWed0b3i6ok5ZKMYYZy7gdJlXw2tC6TIleyMD6OJFswgO9BP9mKY
         MonsjQOW3UlPvlrFcc8IR6PbuKIDt/sevzLXR6HZtEeHXDNyRvTozS9ai7EbRmp/BViv
         7xnCdScSNi0ISqmUPuD9kGsVQxmogeShbiG5QlyeqUZiFN78tx0Z7oKFNcf8EWqTOOG0
         m/+YpEWMQ/gfj1SaihNtFZVlqWSthkGsJ+/Nke4+sa+UfwcgvKzt0ljBfO73fVWIe4Q7
         WBDD7r8USoLe1sZqrBjkxF7WLX6U20qg8Ci+w6lPdwBwgT6zcO3EgYVDKacDOrvbsRdG
         A8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bbL7DykLMjR4IBh+1blOFW3gZb5qagjDzhxfjiFEjd8=;
        b=N3ifG72x9rDuI/5e2etaA6RdH3xeXLL6JKB5RrAvi9fk93wJSBIq8bhB3IQp8JAGQo
         TMWMP+hn/6iYtQjoUQVntT0TTna7nthUIk4Y1xNVhw0H0jU4k4nwba1FCTmFqXuTT0sV
         iMkhHNJFXIazPWf1B3VTYt/0X67zDW+E5hNwCc723EeYzn6N9nrfJ3LtLsboLPC1P1S9
         KoDaEOoCe276eVg3FeWoB3sSIDoEhAjRPgU5ZOdr6gSz/kC2qRYnhqIGM2WV5+oGNWne
         nvja8l9lBJv4H9b1gkY7zUfh+J6f2pblqGrvbs2Kjdqq9t2SiLFWnysXxzl6XPitPFmp
         U3VQ==
X-Gm-Message-State: APjAAAVGiANqmmHFU+iBQ8CDvPofZYNRIcaK4jxoH91UYidUg0v0bfUm
        F6IrXCgVbLeiMsj63GoSfVY=
X-Google-Smtp-Source: APXvYqyOwN5MUuJbgblp1NTy+y/gUkoYCTgxAVuPkvbDAV+zy+hv76xpdSI2yFN+nRPwtZvwR+mpYg==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr3265779pjb.119.1579234509410;
        Thu, 16 Jan 2020 20:15:09 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id k23sm25303816pgg.7.2020.01.16.20.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 20:15:08 -0800 (PST)
Date:   Thu, 16 Jan 2020 20:15:06 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        Timo Kaufmann <timokau@zoho.com>, stable@vger.kernel.org
Subject: Re: [PATCH for v5.5 2/2] Input: rmi_f54: read from FIFO in 32 byte
 blocks
Message-ID: <20200117041506.GD47797@dtor-ws>
References: <20200115124819.3191024-1-hverkuil-cisco@xs4all.nl>
 <20200115124819.3191024-3-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115124819.3191024-3-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

On Wed, Jan 15, 2020 at 01:48:19PM +0100, Hans Verkuil wrote:
> The F54 Report Data is apparently read through a fifo and for
> the smbus protocol that means that between reading a block of 32
> bytes the rmiaddr shouldn't be incremented. However, changing
> that causes other non-fifo reads to fail and so that change was
> reverted.
> 
> This patch changes just the F54 function and it now reads 32 bytes
> at a time from the fifo, using the F54_FIFO_OFFSET to update the
> start address that is used when reading from the fifo.
> 
> This has only been tested with smbus, not with i2c or spi. But I
> suspect that the same is needed there since I think similar
> problems will occur there when reading more than 256 bytes.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reported-by: Timo Kaufmann <timokau@zoho.com>
> Fixes: a284e11c371e ("Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers")
> Cc: stable@vger.kernel.org

As you mentioned this one is not urgent so I dropped the stable
designation (you may forward to stable once it cooks in 5.5 for a bit)
and also dropped fixes as it does not fixes this particular commit but
something that was done before.

Otherwise applied.

Thanks.

-- 
Dmitry
