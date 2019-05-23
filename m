Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D227FD4
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbfEWOgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 10:36:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51943 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730710AbfEWOgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 10:36:09 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hTomd-0004c9-Oe
        for stable@vger.kernel.org; Thu, 23 May 2019 14:33:27 +0000
Received: by mail-qk1-f200.google.com with SMTP id l16so5599076qkk.9
        for <stable@vger.kernel.org>; Thu, 23 May 2019 07:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+W0ZBRDPuAaLAeSp2LgbinBlDum/QNL/K+lovUbkcD4=;
        b=PnrnL5W2g5hNqoylXrIpuUh9cIgE2j8xNr3wL0FU+mNnR5KoPTI0/rbUMivXjhKvih
         ZM/nbi6yJjS7E3BdMQTor9M0L2NepCFcn/LWvokMO6sBouFIvCd8lPgXCgFVBX9GHcM/
         oT8hfVb5CFQt/tk3Y9kxEK9Iz3VVBfkrzV9iWRQWEspVhRdtIlYK5r4oELZWAOhjOIHx
         3jJ4aZZxeX6BAWLxToWYuIVn2fXvJBG89msKu6Nyfrcr0CLaAdV3q6CyzM7Epv0Faprh
         1Lx+m/YymLWucD+EGVv+jkt8oosCARZKGES4nbi5umPeIfoNpNliUSNzhsvwfnBGnUh1
         eP2Q==
X-Gm-Message-State: APjAAAX4kxz1nghmqogZJX6NoSnyTzqluaOYIp+6TyEukibz08pjazXX
        6vbHBF79EoGoVOIlTunAOrM5+d1Dt7QMO2F7SteAf0u97O9mNihsbRNNnbQ/oORSg9HGUQ9ELWk
        GQDG/XXeodGQWdnj/VcyU9eUm72xLRkH3ow==
X-Received: by 2002:a05:620a:158d:: with SMTP id d13mr16893977qkk.271.1558622007015;
        Thu, 23 May 2019 07:33:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz4fx9yFrXtTha0kc9WnfvL/SpBlMkzsC3W/wxnbxEkRyUOM5BUYVF5f7rIG11P0f6vMljE7g==
X-Received: by 2002:a05:620a:158d:: with SMTP id d13mr16893950qkk.271.1558622006798;
        Thu, 23 May 2019 07:33:26 -0700 (PDT)
Received: from [192.168.1.205] (189-47-79-212.dsl.telesp.net.br. [189.47.79.212])
        by smtp.gmail.com with ESMTPSA id m8sm17911949qta.10.2019.05.23.07.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:33:26 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>, hch@infradead.org
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Message-ID: <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com>
Date:   Thu, 23 May 2019 11:33:21 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/05/2019 02:59, Song Liu wrote:
> 
> Applied both patches! Thanks for the fix!

Hi Song, sorry for the annoyance, but the situation of both patches is a
bit confused for me heheh

You mention you've applied both patches - I couldn't find your tree.
Also, Christoph noticed Ming's series fixes both issues and suggested to
drop both my patches in favor of Ming's clean-up, or at least make them
-stable only.

So, what is the current status of the patches? Can we have them on
-stable trees at least? If so, how should I proceed?

Thanks in advance for the clarification!
Cheers,


Guilherme
