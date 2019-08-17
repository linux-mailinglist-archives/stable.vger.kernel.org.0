Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6BF910AA
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfHQOCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 10:02:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34671 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfHQOCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 10:02:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so4627936pfp.1
        for <stable@vger.kernel.org>; Sat, 17 Aug 2019 07:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=h62esfeZoiDH1acW8FoKGWIC9qIxTT8ub8hSb7xJJg4=;
        b=swaqu9+Oe37xfmRYi0zPAW4msIs4kGatDbdMdoURAVMPGXxf3jCoPBlv99lQLpSOWn
         RYsTAoz14pq8WXp/ZGVAIJkmrto9rgS85k7Tsj48o1eBDJNVzqeQomrrSt5mSWFBjIFM
         fRJzZq3nOEwtB3fHq0uPWHegkU8X4E5FxXp+eIY802+BFhPk9N6lSBnUDRMR+X0IGXfZ
         V1dUVKHyAW3NAxoqbFz98VpQ2xX1gEJXvkEzGSkairlCNWYuZFNCZmBB1EF1Jp1/GyBY
         ZTVpt+PcxRgiukwhZ7uRFnshxhxgnRddy2elo8PH1Mw/OE1kQBR04juOLRvPqIN9mkNL
         U5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=h62esfeZoiDH1acW8FoKGWIC9qIxTT8ub8hSb7xJJg4=;
        b=QEc2JgcAbVYqjt55gNWo7kLesxudjq45oSji4SjAPIsYeTjyZdqnHRn7GWFEfALizZ
         Xha51Bjq1HSZSA4d7ikADWTJTOsJCOHA0WxiSnvgkiUCkmtriqzy9EaldBBR0EM9buMY
         8PpQmHkR9wX/hsOt/cMDsUc3+xrSElA7TKaEvM/0LDp1U5JpO7sbu99QktjSazYDCjjh
         sbwgBJbQunZqd96JW0KWJITePlTfLfM+xbpgU8IkPWIgeSwdqJch28RCeVDcKaKA6PKU
         7IAgze0jHjngJp4UZoBoxuZssas6rTYlL7G4oc+rb6q1TQtUhnWrImmi0A+Gxa8bYLqu
         7a6A==
X-Gm-Message-State: APjAAAXOVfqrZHXtEgDdsH2OxDimaEbhdFl5n3+AcbBFXt7US253uqZK
        hfPlIs1U6168+qoG6O+031I=
X-Google-Smtp-Source: APXvYqx/bYinnUpA5gtdado+Mju0/kyMWUvNs/In2RXA95g6aga+0GNiaeAymOXlgHzxpEGzZfLNTg==
X-Received: by 2002:a63:10a:: with SMTP id 10mr12160366pgb.281.1566050543682;
        Sat, 17 Aug 2019 07:02:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11sm10132873pfh.121.2019.08.17.07.02.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 07:02:22 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commits f0f1b8cac4d8 and 7fafcfdf6377 to v4.4.y
Message-ID: <9bac68d5-834c-ec63-a196-1b7ec33d6fdc@roeck-us.net>
Date:   Sat, 17 Aug 2019 07:02:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7fafcfdf6377 ("USB: gadget: f_midi: fixing a possible double-free in f_midi")
fixes CVE-2018-20961. Commit f0f1b8cac4d8 ("usb: gadget: f_midi: fail if set_alt fails
to allocate requests") avoids a context conflict when applying 7fafcfdf6377,
and fixes another minor problem.

Commit 7fafcfdf6377 is present in v4.9.y and v4.14.y.

Thanks,
Guenter
