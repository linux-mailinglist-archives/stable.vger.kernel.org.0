Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4F3314E76
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 12:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBILx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 06:53:58 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:51875
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230251AbhBILxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 06:53:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efjhpSakw//Khj2XNjuGLtcSAnj7q40927PEQUB2M8wX1jcp5lpEjShzzllVOwexPCLtWmiHeFHbORhGWMlEqFa6MD2bD59jPXRsIoLUtfHU3y++DfdTlu9A4id5mvlF59hZdcTEwovrpbT8vwFfhjqaoOHOFEw8NNQZw79YGqWEMCLSV+5nVi5gtZTn3Vtp1qeTyVNI84II0goYKad3NhO5y30UP+9WM+EvDDAGXWeVzQN+IMlCawXQc5nH8ij+rAZJJ14OucWqugYL/BcsCu669j4nLHEQTAlwH4S+GcDIksF+m2WGwCzGbd2U2xqhAxkmMpPL/YkQnhZvDGHd8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E61/uF+cvLFgeIMSKWoY4XDJl0SI8soanaJXqX80pE=;
 b=KRyje62tu4fUe2dJWlC1AYV4P/WikQnjzeGHRlDSInq1+QL2arz2RbHqxCOAbSZB5YbRUD3nOZhpDrpaFF93RagdLXnjr61NpboTpwo9uyDaUS6+w62dgu9Cxhujcd+Fxlbx9c3GT+qIhjBZFS6L8q0aXVBWDF1W5OGROoaO/e3ph/3589abNrD9cBrW4PKz5NMdUaGZFqsvKH/Jsy5ZRDOLqrv6pidwMUIl78NCeRA5wqi8EuVFtoxIFPod/8e7kR8g/nH7DfckIiQ7VLkXjRp++0ZNidHGqV3BhYSkK975YVPX1k/RsBTCc3LfabZP1GM8D0iu2Hrjq21KVtVupQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E61/uF+cvLFgeIMSKWoY4XDJl0SI8soanaJXqX80pE=;
 b=j77qi/03awuX1L/VrAOgN2gzxfI82OlLTJuQkW31D5wvAokmyb1dQvso6vYku6zlwFMGoJuCOUiFjcS74bhjwGZd7yDETXopb5lNkcTzVoLOcvhrcgMERp4Lsf98X+ccLKY71yA4r0xeoxGwKEV76RI/jNqClfoYpwl3ZU79iz8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB0714.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 9 Feb
 2021 11:52:18 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.027; Tue, 9 Feb 2021
 11:52:18 +0000
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
Date:   Tue, 9 Feb 2021 12:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210205172528.GP4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 11:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec6970b7-1252-4b7f-204b-08d8ccf126cf
X-MS-TrafficTypeDiagnostic: PR3P193MB0714:
X-Microsoft-Antispam-PRVS: <PR3P193MB0714CC936C422E30D9B7CE3AFA8E9@PR3P193MB0714.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94b8ye/CRZacxT90G+4m9PLWD1c1yOiNniuyDkHMHAONYUVeMDwQeoUeCeuOsJWvaoKwmJXWtOn3ngOIDMw2QNkRSMSdz+cR8oDxhwBoK1Swxx09qZj7jvMRQbAKt2Q3Wd0CeU/O2k+VMPuF6OK8pgGxVk2I4N0lCaqy8gJT7sfu2DYA9nC+6AO3L6gLq35Om7VbI42zvBnk1zVSIclG4qli6oEJqMZ/gH1TDwFR/cLnVL/t5DnFGKyf5hpav73109sZoLCDxK3czDgx74Ogot04XFE7vjLtj+ZrnZ3rmo6av+Vrbm+r9OvqoZEXPuHb05D5jYnDlb9cN4X6toJuvp/TNuy7RpB5e0rQBz/2f2FUh1CYikVd6pwQSnBzlBn/N+glKz3aQ8WtZtBFI2CSL9Ec2KijAL0O7r50blWM5MdllTbWkgDamuVfJz6QV/6fk4S6qIFX9V6i7u8oS5lddDchZIFgFYG4wW4ldBsIOVxSAASMuYz996fidQe3JN19gJ2zmXevvqV37oWZSlFwOPXcMAXvf02mBRp+xtsnM0qDhgTsV6GYEGs8BMVC2yx/g0CSNDV99g1LmVE8GY8Ij6POT8fsFE+ifincXqikBd1pfogpBuhsRETrIfnbUtBj9ydvZYTc8MqmIVn/wVipkUYNDwb81U2Nxz/lgey6fPvi0AePW3M4yhDRvjw5Dcej
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39830400003)(53546011)(66556008)(66476007)(16576012)(66946007)(4326008)(8936002)(8676002)(478600001)(110136005)(6486002)(86362001)(36756003)(54906003)(52116002)(31686004)(31696002)(186003)(16526019)(5660300002)(2616005)(966005)(316002)(26005)(83380400001)(2906002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MXovUWJOV0dNWWVYenhDaXlmREtJNnhwdWhYZTlDbnZSMWhKdHFrcW1lN2Vs?=
 =?utf-8?B?ekwvZi84YUllTTc0Sm1YR1JLNERiTjhGbWtiUFYyZmRiaVk3YnhIc0s4ME0x?=
 =?utf-8?B?RzVLWG1BTUhVVWZkY3dpMFNtWlFVYzZXU00zazB0dk9UdFVTYUowSXpndDQ4?=
 =?utf-8?B?V0NTakFkbndvQ2dyT1lrNnV5dmdyRC95VzIreTBBdEl3SVVKVWdMVnZhMjM5?=
 =?utf-8?B?M3RvenM4SkpTd093ZCtPMDFtVlJCL2s1ZFA1cHQ4a2N3S3VHWWo2MFVVMjdv?=
 =?utf-8?B?a2RsU2xrUTE5a0lCY0tRNGpmZk1ZbHhJcDhDTzJwRXl3cTN5UGl4aWUwSVJx?=
 =?utf-8?B?ZG53WHlDV1FSNmxOZkFHME9vN2hGZ0RCM2JwMnNaUVZ2cys4TDBNM0czWHh3?=
 =?utf-8?B?ZmZPNmViSW5pODc4dnErU0w1NzZUV01uWjdyNFFTZFpveSsraGtXWUpFbFZs?=
 =?utf-8?B?NVVaYnJ5em5ReURhaVlvNHN3aHJIWTdUcDVld2hKalEydi9Md3AwS0JqSlRu?=
 =?utf-8?B?bjNiYXFHR0pJSG04WHd4K2lTQllPVWtlT2M5TUdTSGdPMzlqUjNkU3pTZy9a?=
 =?utf-8?B?bXpkU0c5b3orS3czWk4vYmRNNTdLQmdza0FzR3FOS1U5eGx6ZWZMWDBDZ2t3?=
 =?utf-8?B?OCt0OElwUGhHZkNyT1psblk3eVJIc2NQMU9QMjd6b1hlS0JRZVVrbmQ1dnlW?=
 =?utf-8?B?SjcxTmZscFlXWmQ0Z2RKSUl6djh2UXIxbUErVm9IUGZSeWFnZXJNMGl3TXkz?=
 =?utf-8?B?VXRRWkQ4Wm1ISzA5dHZBR1Rid2lzcU9EMmd1L25NRWVnckFMZTZvc2NKZmda?=
 =?utf-8?B?SVhSR0FBdWR4NGdGRjlra1RMQitSU2lTV3NFQnQ5YVB0dUp5Sm1oeXQ5YnN6?=
 =?utf-8?B?VkZmenhvWjFtTEpNOUF2N0xmdW1nQXV4cXJjZ1BweEdaZjU2REwramh4bkY2?=
 =?utf-8?B?eFZybTFSVGwxNjh3NkpBRDhsMkgvYnBGbHFkRTRDQ3c4SE1tTHNsN1JkbWFC?=
 =?utf-8?B?dHo3TmxzNmN2T2FPRVlna3cwWXJpV3JXNXZsSnl5L3Nvc2lpS3JKWWpONStZ?=
 =?utf-8?B?RmtWaW50akpoVmlVS1lvWTZZRlNCYlFyRSs1ZTdaaGxyWVMxMDZoR3pFQUFv?=
 =?utf-8?B?blBwaVl3Z0xHTk9lazd2cVRDa2V2blNMVGtITGp1c1dlcklYVWpnWkxuMnl3?=
 =?utf-8?B?bUZTVG1MMUJoQ3I3Si84OEd5ZFlxUEpsaXoxTHZ0MnFuclhWbGhZNk14bzM4?=
 =?utf-8?B?YUMvK1JjTHJBVXJFeFVzbVM4Nk5ZclhyTElqeW9WWkNoekcySDJ0QVBmSjVj?=
 =?utf-8?B?NzRxbTZCNnJONTdBZ1NCY3JmYjlyaU9BRDVPWDJzYWRWVlVhU1phOU1wUlZF?=
 =?utf-8?B?YXdTSjNyTVlHN1NEejNXRXNta1NIL1l3S0UyM0pvN2k4WndDM3dpQ285Q1M5?=
 =?utf-8?B?dlEySm5FaTBJaDg1QVFQMzZmSys3LzBiRm9NZ1FIa2VZNFcwZXJibXl0WW00?=
 =?utf-8?B?RDBDciszWjFkOEVseFF3bHhlVVpnV29iMGs3VHJRdTZoYWJmNVBTSTc2SkVk?=
 =?utf-8?B?UW8zZXN1RW5jSlZjWjBPdWZUc2Q5WXlpcnBRcmVXQy9PQzdneWRsRllDVDk5?=
 =?utf-8?B?QUliNVhUbStYbGhsL011WDFLaE5HaUROcmwrb2tDQWVyNVlpakV5eGdSOFNr?=
 =?utf-8?B?WkZkeWVFYlh4RTAwZU9GaFowcFFlK2h0dFpJVUpWdC9raXplb044bEQ0Y0Vp?=
 =?utf-8?Q?OMt0nE5XnXvhXkUxJphK10vquVYoR4SdyFTfyFI?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6970b7-1252-4b7f-204b-08d8ccf126cf
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 11:52:18.4333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BshUWg+dANQyTI+e8Iccj7g73Zu17c0CJwlNal4frvtUCHOBuX54+6qjNO3j5zVOc84LjWCkPVaBtmNQ/qchw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0714
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On 05.02.21 18:25, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
>>> Thanks for pointing this out. I'd strongly support Jason's proposal:
>>>
>>> https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
>>>
>>> It's the best long-term way to fix this.
>>
>> Really, no it's not.  It introduces extra mechanism we don't need.
> 
>> To recap the issue: character devices already have an automatic
>> mechanism which holds a reference to the struct device while the
>> character node is open so the default is to release resources on final
>> put of the struct device.
> 
> The refcount on the struct device only keeps the memory alive, it
> doesn't say anything about the ops. We still need to lock and check
> the ops each and every time they are used.
> 
> The fact cdev goes all the way till fput means we don't need the extra
> get/put I suggested to Lino at all.
> 
>> The practical consequence of this model is that if you allocate a chip
>> structure with tpm_chip_alloc() you have to release it again by doing a
>> put of *both* devices.
> 
> The final put of the devs should be directly after the
> cdev_device_del(), not in a devm. This became all confused because the
> devs was created during alloc, not register. Having a device that is
> initialized but will never be added is weird.
> 
> See sketch below.
> 
>> Stefan noticed the latter, so we got the bogus patch 8979b02aaf1d
>> ("tpm: Fix reference count to main device") applied which simply breaks
>> the master/slave model by not taking a reference on the master for the
>> slave.  I'm not sure why I didn't notice the problem with this fix at
>> the time, but attention must have been elsewhere.
> 
> Well, this is sort of OK because we never use the devs in TPM1, so we
> end up freeing the chip with a positive refcount on the devs, which is
> weird but not a functional bug.
> 
> Jason
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb7e10910..e07193a0dd4438 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -344,7 +344,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->dev_num = rc;
>  
>  	device_initialize(&chip->dev);
> -	device_initialize(&chip->devs);
>  
>  	chip->dev.class = tpm_class;
>  	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> @@ -352,29 +351,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->dev.parent = pdev;
>  	chip->dev.groups = chip->groups;
>  
> -	chip->devs.parent = pdev;
> -	chip->devs.class = tpmrm_class;
> -	chip->devs.release = tpm_devs_release;
> -	/* get extra reference on main device to hold on
> -	 * behalf of devs.  This holds the chip structure
> -	 * while cdevs is in use.  The corresponding put
> -	 * is in the tpm_devs_release (TPM2 only)
> -	 */
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		get_device(&chip->dev);
> -
>  	if (chip->dev_num == 0)
>  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>  	else
>  		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>  
> -	chip->devs.devt =
> -		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> -
>  	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
> -	if (rc)
> -		goto out;
> -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>  	if (rc)
>  		goto out;
>  
> @@ -382,9 +364,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> -	cdev_init(&chip->cdevs, &tpmrm_fops);
>  	chip->cdev.owner = THIS_MODULE;
> -	chip->cdevs.owner = THIS_MODULE;
>  
>  	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
>  	if (rc) {
> @@ -396,7 +376,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	return chip;
>  
>  out:
> -	put_device(&chip->devs);
>  	put_device(&chip->dev);
>  	return ERR_PTR(rc);
>  }
> @@ -445,13 +424,33 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  	}
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		device_initialize(&chip->devs);
> +		chip->devs.parent = pdev;
> +		chip->devs.class = tpmrm_class;
> +		rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> +		if (rc)
> +			goto out_put_devs;
> +
> +		/*
> +                 * get extra reference on main device to hold on behalf of devs.
> +                 * This holds the chip structure while cdevs is in use. The
> +		 * corresponding put is in the tpm_devs_release.
> +		 */
> +		get_device(&chip->dev);
> +		chip->devs.release = tpm_devs_release;
> +
> +		chip->devs.devt =
> +			MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> +		cdev_init(&chip->cdevs, &tpmrm_fops);
> +		chip->cdevs.owner = THIS_MODULE;
> +
>  		rc = cdev_device_add(&chip->cdevs, &chip->devs);
>  		if (rc) {
>  			dev_err(&chip->devs,
>  				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
>  				dev_name(&chip->devs), MAJOR(chip->devs.devt),
>  				MINOR(chip->devs.devt), rc);
> -			return rc;
> +			goto out_put_devs;
>  		}
>  	}
>  
> @@ -460,6 +459,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>  	mutex_unlock(&idr_lock);
>  
> +out_put_devs:
> +	put_device(&chip->devs);
> +out_del_dev:
> +	cdev_device_del(&chip->cdev);
>  	return rc;
>  }
>  
> @@ -640,8 +643,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
>  		hwrng_unregister(&chip->hwrng);
>  	tpm_bios_log_teardown(chip);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		cdev_device_del(&chip->cdevs, &chip->devs);
> +		put_device(&chip->devs);
> +	}
>  	tpm_del_char_device(chip);
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> 

I tested the solution you scetched and it fixes the issue for me. Will you send a (real) patch for this?

Best regards,
Lino

