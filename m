Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830502F8391
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbhAOSOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387552AbhAOSOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 13:14:41 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6216C06179F
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:13:31 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id b24so9426874otj.0
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YgJn4uwIc2YWK0cg9jX7lXII4wyEt+2IDU2q1mMDShU=;
        b=UsPxhyX90lSDyxVPmMooGY8ndxhTT2f9RNsve0GG7CxSQn+rfdBM+8DsIs5YO7F1EI
         qvN7Ynr1zHM/Fjihlm0lwFk6cxuu3mGBjb3xoT1NhkgMgi+Rygh8bUCKkrGR5iHHxJGm
         9zVyjRAuNb4S8x31dbwd7kfcZOgWr6iS47qF/O+CNPbuRBWEEJtPWd2m826vq3/EDY5T
         /kBtqXtIf5lx/0aECtH4CUa9xF+7A5BJ9e3Wi1SI6Ra5UYtXwMDFy1uUkkRuAWJzXGJ2
         DQq+RfvK9xNpfh8jyoSUWs2IxJQADf4KgU+sUs9QJdvpjIRmD08Da1ojG0U2DRUu+DDA
         F0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YgJn4uwIc2YWK0cg9jX7lXII4wyEt+2IDU2q1mMDShU=;
        b=Sz8PIb1JcmXId/pmnR7K5XsXD3np0jYNtDkKbBYiNhdpZAOept+1UlBkUIHSvcj4UA
         xnOiAtZ27YqKwP7ekWG5CXajWGSrwXTcLvze9GBsvCRp0tTa9JFhDqpjBPcSqbcJhRZS
         3KaLvenk9refiXsezvbTGY0MrdOlh+8xaY7wCFK3RlcvbILHn2K4CgwYohiGowbP0QSP
         ghGVhreoN5I23bTnIeqLVMvMYEXF44qxuru49/ZYjRAsRbEIZ9tdAZ6WpQGnmRDfUA8W
         DUBvgcOIvjPJvkDrmkHAQXs5pRHqlOwW+OBU02mQti72JXqIuCmoHjgxVhOrpcxh6cVa
         hb6A==
X-Gm-Message-State: AOAM531cxbdUSVznN4uDDnq75fnB5KuVFI7I3XrAN51glKpYOzQ+/SIv
        zoqS9iT1j3gOiiZ7hzR0dTqAjSdXOxJfBA==
X-Google-Smtp-Source: ABdhPJxF2xuR5L9s7vtejBmT6ho3OUrHgk5Vf7rbOLQRI7ZG8vh/tj4tynUQ+8COcH4mLQDKt6iEaQ==
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr9246342oth.250.1610734410829;
        Fri, 15 Jan 2021 10:13:30 -0800 (PST)
Received: from nuclearis2-1.gtech (c-98-195-139-126.hsd1.tx.comcast.net. [98.195.139.126])
        by smtp.gmail.com with ESMTPSA id v207sm1795987oif.58.2021.01.15.10.13.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 10:13:29 -0800 (PST)
To:     stable@vger.kernel.org
From:   "Alex G." <mr.nuke.me@gmail.com>
Subject: [PATCH] drm/bridge: sii902x: Enable I/O and core VCC supplies if
 present
Message-ID: <369af9ad-a84f-c0ff-5595-11b80ea56f46@gmail.com>
Date:   Fri, 15 Jan 2021 12:13:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider adding the following fixes to v5.10:

* cc5f7e2fcbe3 drm/bridge: sii902x: Enable I/O and core VCC supplies if 
present
* 4c1e054322da dt-bindings: display: sii902x: Add supply bindings
* 91b5e26731c5 drm/bridge: sii902x: Refactor init code into separate 
function

The STM32MP discovery board is a popular ARM platform, containing a GPU 
and attached display. The display will fail to be initialized if any of 
the DRM bridges fail initialization. The sii9022 bridge only worked 
correctly if the firmware enabled the power supplies on boot. This was 
the case if u-boot was used.

I would like this board to work correctly with v5.10, without needing to 
make assumptions about the firmware.

Thanks,
Alex

