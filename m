Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882145B6E00
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 15:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiIMNKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 09:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiIMNJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 09:09:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07228E08E;
        Tue, 13 Sep 2022 06:09:58 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v1so11765504plo.9;
        Tue, 13 Sep 2022 06:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date;
        bh=HplfPOglv3ZamZq4B3bbFC0qSbQJgjuU0QJdpQQ61Ig=;
        b=R9iwYN5WUzw7sILYdsdBaVcLccgzLCTjfzBKIMn6cxZXcFXnAKlDkC8uB4ppzLU96l
         WqwD8C+QSB14b5dkRUlxMZoAzTFATQoL7zNoGOs4wKe9TGJkQ6BgSl3pBxqp6FUXrZRB
         9bl+ZtolJnQ6Sl753vN3Dwq99d3dOYT4WqzXek4fevoQ2vemNkiyCo/3IrIPpaKvNjJl
         5qp5DspuY1SDd/7hw9ObriWxOb3j85Pj6TZ2r50ChQ87q2APNtBhKscKvMpHjenlWBuC
         rVC9JEa48He8D3SCx0P9N6SUVGc3HLb15cBLEazSRfXXVBME7ZUaJkeHNzQCn+60Ltkn
         EHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date;
        bh=HplfPOglv3ZamZq4B3bbFC0qSbQJgjuU0QJdpQQ61Ig=;
        b=ou/xsRqnZcREDbg683NLWBeYnS5UTctJr+Bi6Jtf9+R0VRM0mzMhzTjxZNxzsCJAOp
         ktSHr24uEohXIZwQeVoIEYgpMgT4ofOvisZr9hGA3L/jFKeVNfZ0vmm2RjS9UpCEoM8r
         RhD6LQE4sO1zIBd+wLcRF1tsAZnAwJ40HOMsMJQB/Ry2rFVlEEv8H7ChkEvv2Ro2VuL6
         lrxV1DXWI1IuCxaz19UKdvJYAxM67kJ103IRVBbb/rR8zPpG/yklek4JJm3Tqulua5Z1
         nFZOnQa45BzjEMtne/yib9T4z7MDhjXaYGnuOYyTaglKexGB/LS3BNeQaRdmpwHf1uT0
         Zxzw==
X-Gm-Message-State: ACgBeo1szBQX5ysvS58qe6PSD4AtnxSZDjk5DaVh8II1+P/GcCMIxPU/
        XPMUo6GhXqCBdJTOaGKscgM=
X-Google-Smtp-Source: AA6agR6D7Wnl+DM0A2GZmVmtXOWp3abUpqmXctmd8U5OR0yPq+gwYpMRAyykHkS9VtfNtgQd8DcVzw==
X-Received: by 2002:a17:90a:6783:b0:1fd:ab56:5af7 with SMTP id o3-20020a17090a678300b001fdab565af7mr4055560pjj.39.1663074597393;
        Tue, 13 Sep 2022 06:09:57 -0700 (PDT)
Received: from [192.168.10.107] ([117.176.186.9])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902714f00b00174f61a7d09sm8212717plm.247.2022.09.13.06.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 06:09:56 -0700 (PDT)
Message-ID: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
Date:   Tue, 13 Sep 2022 21:09:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
From:   yong <yongw.pur@gmail.com>
Subject: Re: [PATCH v4] page_alloc: consider highatomic reserve in watermark
 fast
To:     jaewon31.kim@samsung.com, gregkh@linuxfoundation.org,
        mhocko@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        wang.yong12@zte.com.cn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
This patch is required to be patched in linux-5.4.y and linux-4.19.y.

In addition to that, the following two patches are somewhat related:

	3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
	9282012 page_alloc: fix invalid watermark check on a negative value

thanks.
	
	

