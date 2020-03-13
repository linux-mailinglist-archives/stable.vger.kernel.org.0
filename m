Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974C4184189
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 08:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgCMHe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 03:34:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40029 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMHe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 03:34:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so3826014plk.7;
        Fri, 13 Mar 2020 00:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iqIrEWPHtK36KHL97scoySA1zOUO14/T0uQX8yO3Kk4=;
        b=sV3fgjNCxZa0NMDNX/eEDrLKybxnbFPT9ahm32wdl+TFAc79eudak0fkV/AKFyVMRK
         P5TaBgoZogmiAbxPUktzbaUZhrx8EAPNBjccwhvMxwKy+1g4Kk0npunlc4CjacaX34oj
         gtcK0uxZKjD8VMkA2Pi8s95+su1IwX4Z/3Gb30Vbu/nDu4rauGMf5po6aY/5v+2LrSEw
         wsC7TTAFZEVoyfFbqE2UEqbUyh+9VR02yTk+fOt7rbP+Jjt7HXbHqov2oyAaO6qo+ZX2
         j8Ff3u6/i/TLJKw9AptcLT6l6lYnM3AM/rk3DFD9DUdphRcybMEKEQyzDzXzm/zoEmup
         Jdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iqIrEWPHtK36KHL97scoySA1zOUO14/T0uQX8yO3Kk4=;
        b=EDJ6k7DLQlJZDNiKk9JYIFuRMdNdCnKsyA7YIystKS3RJ4QgN/6oW8g0GbDbAffdRW
         o1cV68o++y0tgTqwyZjJxLbjd0sTqRhHwrwDHe+37asp0b6RRy+a9CVqPjIqSGKVtxQ0
         SfYE1XTjbFr5aTfzehMALuQNDe0xjODelxSCgOSA4hSjhYNW/mPzjT7ybQi246niqDsw
         ifN/mwjwpldwe4cKSn9XlQvyIkSco/zAhmp3zZXXzmEdTWquXZwWVaEM7WHS1WXJXJXb
         IVdOAjKJwoNsktBdlD+mbkR2V+0T4Nsn7tMm01ommJ7JCRWZL1ScPNyabF/ZwZ+zmd8W
         NmtQ==
X-Gm-Message-State: ANhLgQ2fqIj/7t+1u/0lIOcytMKNKg0+R2dzfYu2jAd0VwLpQ2aKO/VT
        0juH/BKNhbOL1DK5nki0pF4=
X-Google-Smtp-Source: ADFU+vvt5Yz6wpzYZKQnDeW9SKZ45i0fLG+ULFfNUkt+9fPbu7uWpM9sM6imSkYH1mxkGqS/YrK5TA==
X-Received: by 2002:a17:90b:1954:: with SMTP id nk20mr8418374pjb.69.1584084868541;
        Fri, 13 Mar 2020 00:34:28 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5bbb:c872:f2b1:f53b])
        by smtp.gmail.com with ESMTPSA id u11sm10965653pjn.2.2020.03.13.00.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 00:34:27 -0700 (PDT)
Date:   Fri, 13 Mar 2020 16:34:25 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200313073425.GA219881@google.com>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313003533.2203429-1-bmeneg@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/03/12 21:35), Bruno Meneguele wrote:
> 
> Userspace libraries, e.g. glibc's dprintf(), expect the default return value
> for invalid seek situations: -ESPIPE, but when the IO was over /dev/kmsg the
> current state of kernel code was returning the generic case of an -EINVAL.
> Hence, userspace programs were not behaving as expected or documented.
> 

Hmm. I don't think I see ESPIPE in documentation [0], [1], [2]

[0] https://pubs.opengroup.org/onlinepubs/9699919799/functions/fprintf.html
[1] http://man7.org/linux/man-pages/man3/dprintf.3p.html
[2] http://man7.org/linux/man-pages/man3/fprintf.3p.html

	-ss
