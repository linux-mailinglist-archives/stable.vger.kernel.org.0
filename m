Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C071426BD10
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIPG2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:28:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgIPG2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 02:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600237714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vm7+Uaq7tdl2nli2GIaqtVYWdw048BSj6kRXk+g870g=;
        b=DhwiBgDKuP8yRKB3URXr3eG2sp0XmpZtbR6dJmhSdglXrDPiyRoDDdKsHwdozbWpfZXT6y
        zVUA/CZLrwg+ofQskzbI1QO536ZK6L3bSMieMT091xgOIWPRqojmIWNR82AYe6fbwRLKj2
        u8Sbe8IGgV5sJbM+06hAt1DLL9hAA0A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-S7zojkE2OBaEU4x728RPnw-1; Wed, 16 Sep 2020 02:28:32 -0400
X-MC-Unique: S7zojkE2OBaEU4x728RPnw-1
Received: by mail-ed1-f70.google.com with SMTP id bm14so2067329edb.2
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 23:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Vm7+Uaq7tdl2nli2GIaqtVYWdw048BSj6kRXk+g870g=;
        b=Su3ugvnp5JZ1/soNrNPsk18DPrCbqyKiwDrWBgY8M7sPMaFGLbj9My5JKT3WtviYa4
         pCHqSndEAxxtf0AIrae6GNOLgt+UuS5HX3RSBq15S/H0/B1UexRoeHklT5LvPn3oym4v
         d4I1cXCU/TyRTva1OH/g6+W3AN+r6zmf3WVBECKcCbgBJ+Dhsn4IzpGzFCF4uKLvijm+
         5gi0tqUdPoBEZq/fmpBp089doynP/usHQcbJxhOZB0Yi41s+B2CfOq62T04nYk4h5N3B
         1p7ZEThq54/rqDSBGhBxZ5vNFLG188VX6IetjlyZPEDt0Tg96Q1hnipLLUM5FZtz/MI1
         ucSQ==
X-Gm-Message-State: AOAM5318OpOdWWkNVWw0pZ5z73lIBz3qCHfVnUEC0wa45MVLJqy9ORkv
        4rTlWHl5MeCHU+3D+ijTiv8mjdKWwhSgBTZtcL4d+h42JzcWX2E69oCnrPwH+Ig3rWX4NNLVaCP
        A8Wu0dNLlvoLb2IAJ
X-Received: by 2002:a17:906:15c4:: with SMTP id l4mr23375896ejd.78.1600237710900;
        Tue, 15 Sep 2020 23:28:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfHEW6aJL0OqkrdbnBesTqxr0loZesamzN56KCy94iUtwUJ8m++pGEBYVVY8RTfOYgGWostQ==
X-Received: by 2002:a17:906:15c4:: with SMTP id l4mr23375884ejd.78.1600237710652;
        Tue, 15 Sep 2020 23:28:30 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id r9sm11616758eji.111.2020.09.15.23.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 23:28:30 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Dan Crawford <dnlcrwfrd@gmail.com>
Cc:     stable@vger.kernel.org
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Sound regression in 5.8.8 caused by "ALSA: hda - Fix silent audio
 output and corrupted input on MSI X570-A PRO"
Message-ID: <7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com>
Date:   Wed, 16 Sep 2020 08:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

This bug got filed against Fedora last night:
https://bugzilla.redhat.com/show_bug.cgi?id=1879277
"1879277 - Audio ducking after Linux kernel 5.8.8 update, with headphones plugged in"

The system in the bug is using a MSI X570-A PRO motherboard. So this is almost
certainly (this has not been confirmed) caused by commit 8e83bd51016a in the
stable tree: "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO".

I'm not sure how to proceed with this one for the stable series,
I guess a revert is in order, but that may (re)break non headphone usage?

Takashi, do you have any suggestions?

For more info please directly contact the reporter through bugzilla.

Regards,

Hans

