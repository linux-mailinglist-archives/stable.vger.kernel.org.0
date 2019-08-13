Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B28BE0C
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfHMQQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 12:16:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45547 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbfHMQQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 12:16:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id k13so9608452qtm.12
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 09:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=26Jan7zsP3flWJT/a+lsUdj+wOGb1yxAvmrDzfd5D4s=;
        b=HI8nrpZQvAGP5ubPIaZ9IeOs6xrVe135CaNwT9DR5n+FZUk7Ssf+CpCZg4j3t0JRZ3
         dBcWuNv06AO5aogk+Q129HsWAubWfWm6yxRbyAiLP0HQs+g4mujC/ZpemEv5iYzTuRyW
         iuPQ51kN4jbnjJyfLq/ZmlRV4Eicq7EEU0y7AZDfafJTtCFQDsiO7muBQQCAIZK3F5cG
         YmQqPcIWnINgbC00nyrjKXiM29wO5ZH+xji/d+7tZCcv72LWNbcWwBQ9JNcz78Pj5J1b
         NGqJJUX4crnRt3B664tC4K0NBzEJEn9VFwagi9bv00U/v8yx4vLnlfsQgODCgL1fMkgc
         uGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=26Jan7zsP3flWJT/a+lsUdj+wOGb1yxAvmrDzfd5D4s=;
        b=WJ8xRjjZoQg5fJhPBmTDiF+GZ+f+VRY9/kCw35LGCJrzCXj0fPoOe53hnG7q/Pts+C
         niaAX6Kwr50o+HzCnf573fE6AH6CwR7Mvh9Dlfv8nT6dC4sc5Rv4V2Icvz7Na5MM0dFH
         mosgImKI3iuP1LwvByl98LnNOrZ9jBRIUQd8mU/I/MiLwAsSJnkUe+kOoriN+JQSu7Ec
         xlczdx9wGs8dCzqzwBXQAoY2KjWgzFHBbqxwmFqcCXFxCs2G6QtUNOYERuw7r8PXMVtR
         77lgrV6rGnXgC+FcGUjWxZGhXRIKWPDLg7T17LsouIfZi0HVAiCLwZLoQEKZVyvjcXeg
         t4mA==
X-Gm-Message-State: APjAAAVGZbHY1mIgOzk+2W+iCKOyezWtZyTBA5eg1atgOoHlwasVWVjG
        simhNqh4uemIDfDrFRC55+9E5A==
X-Google-Smtp-Source: APXvYqwWPWfUSCTIPEF+PdPEkt5dwm78QDH5CjAcEjrybJSkwfmDnEmnd5QoBbjUjpeoSXbFhI4RIw==
X-Received: by 2002:ac8:30f3:: with SMTP id w48mr33102787qta.216.1565712967126;
        Tue, 13 Aug 2019 09:16:07 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d12sm45016082qtj.50.2019.08.13.09.16.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 09:16:06 -0700 (PDT)
Date:   Tue, 13 Aug 2019 12:16:05 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Mike Christie <mchristi@redhat.com>
Cc:     josef@toxicpanda.com, linux-block@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/1] nbd: fix max number of supported devs
Message-ID: <20190813161605.gohrcsl7hxoqiozn@MacBook-Pro-91.local>
References: <20190804191006.5359-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804191006.5359-1-mchristi@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 04, 2019 at 02:10:06PM -0500, Mike Christie wrote:
> This fixes a bug added in 4.10 with commit:
> 
> commit 9561a7ade0c205bc2ee035a2ac880478dcc1a024
> Author: Josef Bacik <jbacik@fb.com>
> Date:   Tue Nov 22 14:04:40 2016 -0500
> 
>     nbd: add multi-connection support
> 
> that limited the number of devices to 256. Before the patch we could
> create 1000s of devices, but the patch switched us from using our
> own thread to using a work queue which has a default limit of 256
> active works.
> 
> The problem is that our recv_work function sits in a loop until
> disconnection but only handles IO for one connection. The work is
> started when the connection is started/restarted, but if we end up
> creating 257 or more connections, the queue_work call just queues
> connection257+'s recv_work and that waits for connection 1 - 256's
> recv_work to be disconnected and that work instance completing.
> 
> Instead of reverting back to kthreads, this has us allocate a
> workqueue_struct per device, so we can block in the work.

Woops, thanks for fixing this.  Sorry I was out of the office when this went
through and forgot to come back to it.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
