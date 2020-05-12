Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D211D035E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 02:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgEMAAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 20:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731875AbgEMAAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 20:00:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85D6C061A0C;
        Tue, 12 May 2020 17:00:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so18423191wrt.9;
        Tue, 12 May 2020 17:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q5/ek6Sjnd7HyclvXi3ldLv2j2enJrcBzkYub6qK8tw=;
        b=Vdzc2ApqlwFV9ngi7DcrQq1BmHXDrnGesYtUMul3bvxWxfzc2bMjWEJNUGMdDVGCad
         xMYJe0F0p+ctqiw/SYRPLPfXuDV0XSZQfq4qXlHxl9AZ3bS6LP7iMOXCq5ueQFNaPMIA
         /fPl+OL8B6G4jjtfxt/i/EmXj2dVdSuYMU3TQSn1rpujr4JoSz5bY8che5U8DY4QqJ9S
         HBm5oGvwdIAjd4Vm19bFnVrt4/5/eJPgH7oFT7LZgJkDKZQeC3ESRAWBz7AXOclt+NXe
         5+UYq9FwMOJMZITfa0TY536W08kfHQv5LJbQ23V/CCgFYeOPd9fPKF9TEtLdA8JuUu5A
         e25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5/ek6Sjnd7HyclvXi3ldLv2j2enJrcBzkYub6qK8tw=;
        b=UqMbdh7PIG51cpeyZbuMwUETWNRZ2QBZVuD6Q0/iBI1ZxLgv3MxAOFZslPkRxrp7Zw
         NElfjZ2o97pUQjhOq1htBwUCPeqLQ2VtyYuV5Otv25Zx0lGdJ/1QMSmHnE9PRDhaj/Yh
         oRT+y2u2ap4r8FpxBS8s/XyvaHQ1CIvhG+IXJPd5tDTzYLRRv0EZXnjwg+rQzD5TEgf9
         jjwR0cztbk9KCk+Ti2fF/8xxbcrxkHmnkueM2IoZ0NwZP53R7sGB4t5PUb0TUOAG0/5N
         TKTuIVTKr7aJBysZE9Y1Z0entykGvQkdsp866Vm6TJU6Q62UimZ5YI0lWaEdCjWvj2zK
         2+mQ==
X-Gm-Message-State: AGi0Pub++oOCJwNFJdxYLAw0cfzTzFCM+7Cmb3FBFinNIR/eMgzZsnF9
        43dGvD7aMcRiJviP0jPhUpe8tTPT
X-Google-Smtp-Source: APiQypLqRkpKWnoLxb9jNzXC8IDVxIHunqfbj84imF58HXjxZkorRwJhF7nHYbtOo39e1WYBGKRNIw==
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr26443587wrk.232.1589328001533;
        Tue, 12 May 2020 17:00:01 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 60sm1898982wrp.92.2020.05.12.16.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 17:00:00 -0700 (PDT)
Subject: Re: [PATCH 03/12] lpfc: Fix broken Credit Recovery after driver load
To:     Chris Hofstaedtler <chris.hofstaedtler@deduktiva.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
 <20200128002312.16346-4-jsmart2021@gmail.com>
 <20200512212855.36q2ut2io2cdtagn@zeha.at>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <f75f508a-deaf-f0d3-b394-c4377f7848b5@gmail.com>
Date:   Tue, 12 May 2020 16:59:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512212855.36q2ut2io2cdtagn@zeha.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/2020 2:28 PM, Chris Hofstaedtler wrote:
> Hi,
> 
> this commit, applied in Ubuntu's 5.4.0-30.34 tree as
> 77d5805eafdb5c42bdfe78f058ad9c40ee1278b4, appears to cause our
> HPE-branded 2-port 8Gb lpfcs to report FLOGI errors. Reverting it fixes target
> discovery for me. See below for log messages and HW details.
> 
>...
> Let me know if you need further debug logs or something.
> 
> Thanks,
> 

I'm more interested in what other patches you do or do not have in your 
tree.

This is the message that threw it to the left:
0237 Pending Link Event during Discovery

Let me look a little.

-- james
