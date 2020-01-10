Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C28137882
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 22:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgAJV37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 16:29:59 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36200 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgAJV37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 16:29:59 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so3169599oic.3
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 13:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n2mxxlKQ3z5GTVr0sFZ/UO3UPo2+qy5+H2Pzt1Zkygo=;
        b=dCEwU9ocO7qaLRqzQSLmYs/X59vGdpavT680mPOTiWdjYqJpoXuFoEB85fEAbl/R3p
         /y3AKOYu3spzlXqH/C61jCHa9TIHmuFBmGDnoA5qtqUaZmeSgyxy3V1zTF0Elay4sM09
         u0Ul91Reo0p8yrhytuqg9BsiOFdgxiv50nTGAt9IOy3SYbLoOoyFhWgvWsZVN6lPg6VG
         IFp7ItvVS2lWbifAFtj5ruAuABfk1/GLKmZ7tTkhRQxlrzDPIJFrv8+QoU3gi4HLluQO
         0kns4yL3aTNMjHPY/3bhjJxF58/xBa22EVXeeDBGQUCDPEQCTpMi86FzgDz1gulGpc8E
         n5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n2mxxlKQ3z5GTVr0sFZ/UO3UPo2+qy5+H2Pzt1Zkygo=;
        b=PxZ7igSFaor8DBfIJgOsG7DL0XRxN//aVmVQZ7svRWdQBtAxgkFKCUy2hmEoZXGDdI
         hIvBnfGeEcW9KIfzsJ1XqgriefdKMYdLXWFngoDqQrwMPh3MhLYWrjvB8JbrLpQ5BxC4
         XZUqEUpB8myd3t1vHzkZKSjwcJyn9vkhosC5hogoqh42pycjZoTMLe+9KZGWKpQx0ckZ
         dqEhqjW4sdcRUKd0D3gABj9XBse8z81EndpeShL57W6Vo/Fr+ueD4iB+YA3ZyIcMvPWv
         R+kH7uHcbIN850oEOMH2DpvH+9fsEFrPrX/r/Yw4qpt9fKZTiKldsfuOh+cVB4LN2g/W
         0q2A==
X-Gm-Message-State: APjAAAUCVSu/ot8n3fiWWGZvjX9XTlvK6RbmtzPAOkDkKYLQ+PkYZ94N
        VeRvhUICfeFhDRg27xBUGL2PozKyXzbq8pas8L/H/A==
X-Google-Smtp-Source: APXvYqwxQz8fxi8L1VftblbeLJlRU9OyUs7b4BgCeeRqP9aOQVdGF6FRWI3UMAhHXqhXuMwGJ1X7oILHYEfQbi0fDDE=
X-Received: by 2002:aca:3f54:: with SMTP id m81mr3657692oia.73.1578691798574;
 Fri, 10 Jan 2020 13:29:58 -0800 (PST)
MIME-Version: 1.0
References: <157868988882.2387473.11703138480034171351.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <157868988882.2387473.11703138480034171351.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 13:29:47 -0800
Message-ID: <CAPcyv4j=rhEN6M-h=p=4GHYTj2vQEsG5kQVKKwaM6U1CHLOPyA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 1:16 PM Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> Changes since v2 [1]:
> - Apologies I overlooked that I had local changes in my tree to fix a
>   compiler error (misspelled assert_held_device_hotplug()). Now fixed
>   up.
>
[..]
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 96ff76731e93..e042da3b1953 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1553,6 +1553,7 @@ static inline bool device_supports_offline(struct device *dev)
>  extern void lock_device_hotplug(void);
>  extern void unlock_device_hotplug(void);
>  extern int lock_device_hotplug_sysfs(void);
> +extern void assert_held_device_hotlpug(void);

Argh, did it again. I definitely need to fix stg mail to not send
patches while there are local changes pending in the tree.
